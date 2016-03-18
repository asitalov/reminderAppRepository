//
//  YLCheckToUnlockViewController.m
//  YLSwipeLockViewDemo
//
//  Created by 肖 玉龙 on 15/2/28.
//  Copyright (c) 2015年 Yulong Xiao. All rights reserved.
//

#import "YLCheckToUnlockViewController.h"
#import "YLSwipeLockView.h"


@interface YLCheckToUnlockViewController ()<YLSwipeLockViewDelegate>
{
    UIView *blockView;
    UILabel *messageLabel;
    NSTimer *timer;
 
}

@property (nonatomic, weak) YLSwipeLockView *lockView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic) NSUInteger unmatchCounter;
@property (nonatomic, weak) UILabel *counterLabel;

//@property (nonatomic, weak) UIView *blockView;
@end

@implementation YLCheckToUnlockViewController

int hours, minutes, seconds;
int secondsLeft;

- (void)updateCounter:(NSTimer *)theTimer {
    
    if(secondsLeft > 0 ) {
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        messageLabel.text = [NSString stringWithFormat:@"Failed to access 5 times, try again in: %02d:%02d", minutes, seconds];
    } else {
        secondsLeft = 300;
    }
}

-(void)countdownTimer {
    
   
    
    if (timer == nil) {
         secondsLeft = 300;
        secondsLeft = hours = minutes = seconds = 0;
      //  [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    } else {
        
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
  //@@@@@ should be somewhere else
    
    self.view.backgroundColor = [UIColor colorWithRed:35/255.0 green:39/255.0 blue:54/255.0 alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"swipe to unlock";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(10, 60, self.view.bounds.size.width - 20, 20);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, self.view.bounds.size.width - 20, 20)];
    counterLabel.textColor = [UIColor redColor];
    counterLabel.textAlignment = NSTextAlignmentCenter;
    counterLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:counterLabel];
    self.counterLabel = counterLabel;
    self.counterLabel.hidden = YES;
    
    
    CGFloat viewWidth = self.view.bounds.size.width - 40;
    CGFloat viewHeight = viewWidth;
    
    YLSwipeLockView *lockView = [[YLSwipeLockView alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - viewHeight - 40 - 100, viewWidth, viewHeight)];
    [self.view addSubview:lockView];
    
    self.lockView = lockView;
    self.lockView.delegate = self;
    
    self.unmatchCounter = 5;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePassword"];
    if ([savedPassword isEqualToString:password]) {
        [self dismiss];
        return YLSwipeLockViewStateNormal;
    }else{
        self.unmatchCounter--;
        if (self.unmatchCounter == 0) {
            
            self.counterLabel.text = @"5 times unmatched";
            self.counterLabel.hidden = NO;
            
            [self performSelector:@selector(addBlockView) withObject:nil afterDelay:0];
            [self performSelector:@selector(dismissBlockView) withObject:nil afterDelay:300];
            [self countdownTimer];
            //[self performSelector:@selector(dismiss) withObject:nil afterDelay:5];
            
        // [self performSelector:@selector(dismissViewController) withObject:self afterDelay:5]; // DISMISSING THE BLOCK SCREEN!!!!!
            
        }else {
            
            self.counterLabel.text = [NSString stringWithFormat:@"unmatched, %lu times left", (unsigned long)self.unmatchCounter];
            self.counterLabel.hidden = NO;
        }
        return YLSwipeLockViewStateWarning;
    }
}
- (void) addBlockView {
    
    blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 360)];
   // messageLabel.frame = CGRectMake(0, 0, 160, 360);
    messageLabel.numberOfLines = 3;//UILabel(frame: CGRectMake(0, 0, 200, 84))
    // NSLog(@"black frame %@", NSStringFromCGRect(blackView.frame));
    
    messageLabel.text = @"Failed to access 5 times, try again in: 05:00";
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.textAlignment = UITextAlignmentCenter;
    blockView.backgroundColor = [UIColor colorWithRed:35/255.0 green:39/255.0 blue:54/255.0 alpha:0.5];
    self.unmatchCounter = 5;

        
         [self.view addSubview:blockView];
    [blockView addSubview:messageLabel];
  

   
}

- (void) viewDidLayoutSubviews
{
    messageLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 200);
    //CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2)
}

- (void) dismissBlockView {
    
    [blockView removeFromSuperview];
}

- (void)dismissViewController   // DISMISSING THE BLOCK SCREEN!!!!!
{
    //if you are pushing your viewControler, then use below single line code
   // [self.navigationController popViewControllerAnimated:YES];
    //if you are presnting ViewController modally. then use below code
    //[self dismissModalViewControllerAnimated:YES];
   
}

-(void)dismiss{
    
    if (self.presentingViewController) {
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}



@end
