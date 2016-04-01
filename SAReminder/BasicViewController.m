//
//  BasicViewController.m
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import "BasicViewController.h"
#import <CoreData/CoreData.h>
#import "SAReminder-swift.h"


@interface BasicViewController() <NSFetchedResultsControllerDelegate> {
    
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
    NSDate *_newDate1;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation BasicViewController

- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notes"];
    
    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"dateInDateFormat" ascending:YES];
    [request setPropertiesToFetch:@[@"dateInDateFormat"]];
    
    [request setSortDescriptors:@[lastNameSort]];
    
   // NSManagedObjectContext *moc = …; //Retrieve the main queue NSManagedObjectContext
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    
    self.title = @"Basic";
    
    return self;
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate];
}

- (IBAction)didChangeModeTouch
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 300;
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 85.;
    }
    
    //self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor brownColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
   
    _newDate1 = [_dateSelected dateByAddingTimeInterval:60*60*24];
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    
    [self compareDates];
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:0];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:5];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (NSArray*)getEntityDescriptionArray {
    
    NSEntityDescription *entity = [NSEntityDescription  entityForName:@"Notes" inManagedObjectContext:_context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[@"dateInDateFormat"]];
    
    // Execute the fetch.
    NSError *error;
    NSArray *objects = [_context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // Handle the error.
    }

    return objects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[GetBackgroundImage getImage]];
    self.tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar"];
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    [self getEntityDescriptionArray];
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getEntityDescriptionArray];
    [self createRandomEvents];
 
}



- (void) compareDates {
    
     for(int i = 0; i <  [self.getEntityDescriptionArray count]; ++i){
         
          NSDictionary *dict = [self.getEntityDescriptionArray objectAtIndex:i];
          NSDate *dateToCompare = [dict[@"dateInDateFormat"] dateByAddingTimeInterval:60*60*24];
         
         NSCalendar* calendar = [NSCalendar currentCalendar];
         unsigned unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
         
         NSDateComponents *comp1 = [calendar components:unitFlags fromDate:_newDate1];
         NSDateComponents *comp2 = [calendar components:unitFlags fromDate:dateToCompare];
         
         NSDate *dte1 = [calendar dateFromComponents:comp1];
         NSDate *dte2 = [calendar dateFromComponents:comp2];
         
         if ([dte1 isEqualToDate:dte2]) {
             NSLog(@"equal dates");
             NSMutableDictionary *dict = [NSMutableDictionary new];
             [dict setValue:dte1 forKey:@"searchDate"];
             NSNotification *notification = [NSNotification notificationWithName:@"MyNotification" object:nil userInfo:dict];
             [[NSNotificationCenter defaultCenter] postNotification:notification];
             
             [self.tabBarController setSelectedIndex:0];
         }

         
     }
}

- (void)createRandomEvents
{
    
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i <  [self.getEntityDescriptionArray count]; ++i){
        
        NSDictionary *dict = [self.getEntityDescriptionArray objectAtIndex:i];

        NSString *key = [[self dateFormatter] stringFromDate:dict[@"dateInDateFormat"]];  // randomDate IN STRING FORMAT
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:dict];
    }
}

@end
