//
//  New_Note.swift
//  SAReminder
//
//  Created by Admin on 09.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData

var selectedIndexPath2 : NSIndexPath?

protocol newNote {
    
     func updateLabelText(newLabel: String)
     func updateLabelContent(newLabel: String)
     func updateLabelIndex(newIndex: Int)
    
}

class New_Note: UIViewController, UITextViewDelegate, HHAlertViewDelegate, UITableViewDelegate, newNote, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var settingsTable: UITableView!
    let dateformatter = NSDateFormatter ()
    var dateValue = NSString ()
    var dict = NSMutableDictionary ()
    var theAlarmDate = NSDate()
    var notificationText = NSString()
    var settingsArray = NSArray()
    var remindArray = NSArray()
    var labelText:NSString?
    var labelContent:NSString?
    var labelInteger:Int?
    var imageNameText:NSString?
    var delegate: newNote?
    var titleText:String?

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var childButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!

    let alertVC = HHAlertView()
   
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let notesFetchRequest = NSFetchRequest(entityName: "Notes")
        
        let primarySortDescriptor = NSSortDescriptor(key: "titleText", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let thirdSortDescriptor = NSSortDescriptor(key: "buttonName", ascending: true)
        
        
        notesFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor, thirdSortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: notesFetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        print("animalFetch = \( notesFetchRequest)")
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
            
        }
        if selectedIndexPath2 != nil {
            
        let notes = fetchedResultsController.objectAtIndexPath(selectedIndexPath2!) as! Notes
            labelText = notes.titleText
            labelContent = notes.contentText
            let integerValue = Int(notes.index! as NSNumber)
            labelInteger = integerValue
            
            imageNameText = notes.buttonName
            if imageNameText == "child-selected.png" {
                childButton.selected = true
                childButton.setImage(UIImage(named: "child-selected.png"), forState: .Selected)
            } else if imageNameText == "phone-selected.png" {
                phoneButton.selected = true
                phoneButton.setImage(UIImage(named: "phone-selected.png"), forState: .Selected)
            } else if imageNameText == "shopping-cart-selected.png" {
                shoppingCartButton.selected = true
                shoppingCartButton.setImage(UIImage(named: "shopping-cart-selected.png"), forState: .Selected)
            } else if imageNameText == "travel-selected.png" {
                travelButton.selected = true
                travelButton.setImage(UIImage(named: "travel-selected.png"), forState: .Selected)
            }
            
        } else {
            
            labelText = "Place title here"
            labelContent = "Content text"
            labelInteger = 0
        }
     
        self.title = titleText
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.picker.backgroundColor = UIColor.whiteColor()
        settingsArray = ["Title", "Content", "Remind before", "Alarm"]
        remindArray = ["dont remind", "5 mins", "10 mins", "15 mins", "30 mins", "1 hour", "2 hours", "1 day"]
        
        HHAlertView.shared().delegate = self

        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.dateFormat="MM.dd hh:mm"
        
        dateValue = dateformatter.stringFromDate(picker.date)

        picker.addTarget(self, action: Selector("dataPickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
     

    }

    func resetButtons() {
        childButton.selected = false
        phoneButton.selected = false
        shoppingCartButton.selected = false
        travelButton.selected = false
    }
    
    @IBAction func childTapped(sender: AnyObject) {
        resetButtons()
       
        childButton.selected = true
        childButton.setImage(UIImage(named: "child-selected.png"), forState: .Selected)
    }
    
    @IBAction func phoneTapped(sender: AnyObject) {
        resetButtons()
        phoneButton.selected = true
        phoneButton.setImage(UIImage(named: "phone-selected.png"), forState: .Selected)

    }
    
    @IBAction func shoppingCartTapped(sender: AnyObject) {
        resetButtons()
        shoppingCartButton.selected = true
        shoppingCartButton.setImage(UIImage(named: "shopping-cart-selected.png"), forState: .Selected)
    }
    
    @IBAction func travelTapped(sender: AnyObject) {
        resetButtons()
        travelButton.selected = true
        travelButton.setImage(UIImage(named: "travel-selected.png"), forState: .Selected)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func saveChanges(sender: UIBarButtonItem) {
        
      if labelText == "Place title here"{
        HHAlertView .showAlertWithStyle(HHAlertStyle.Wraing, inView: self.view, title: "Reminder", detail: "Please add a message for notification", cancelButton: nil, okbutton: "OK")
        
      } else {
        
        var image = ""
        
        if childButton.selected {
            image = "child-selected.png"
        }
        else if phoneButton.selected {
            image = "phone-selected.png"
        }
        else if shoppingCartButton.selected {
            image = "shopping-cart-selected.png"
        }
        else if travelButton.selected {
            image = "travel-selected.png"
        }
        
        scheduleNotification()
        
        // CoreData
        if selectedIndexPath2 != nil {
            
            let notes = fetchedResultsController.objectAtIndexPath(selectedIndexPath2!) as! Notes
            
            notes.setValue(labelText, forKey: "titleText")
            notes.setValue(dateValue, forKey: "date")
            notes.setValue(image, forKey: "buttonName")
            notes.setValue(labelContent, forKey: "contentText")
            
            do {
                try notes.managedObjectContext!.save()
            } catch {
                print(error)
            }

        } else {
            
        let notes =  NSEntityDescription.entityForName("Notes",
            inManagedObjectContext:managedObjectContext)
        let nextNote = NSManagedObject(entity: notes!, insertIntoManagedObjectContext: self.managedObjectContext)
       
        nextNote.setValue(labelText, forKey: "titleText")
        nextNote.setValue(dateValue, forKey: "date")
        nextNote.setValue(image, forKey: "buttonName")
        nextNote.setValue(labelContent, forKey: "contentText")
        
        let castAsNSNumber = NSNumber(integer: labelInteger!)
        
        nextNote.setValue(castAsNSNumber, forKey: "index")
      
        do {
            try nextNote.managedObjectContext!.save()
        } catch {
            print(error)
        }
        }
        }

    }
    
    func scheduleNotification () {
        
        let currentDate = NSDate ()
        
        let dateFormatter = NSDateFormatter()
        let dateFormatter2 = NSDateFormatter()
        
        dateFormatter.dateFormat = "YYYY.MM.dd hh:mm"
       // dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT +2:00")
        
        dateFormatter2.dateFormat = "YYYY"
        //Got the current year = 2016 in string
        let currentDateString = dateFormatter2.stringFromDate(currentDate)
        
        //Got current date in string: 2016-03-11 07:48:53 +0000
        let connectedDate = "\(currentDateString), \(dateValue)"
        
        //connectedDate (YYYY + MM.dd hh:mm) = 2016, 03.11 09:48
        print ("connectedDate = \(connectedDate)")
        
        //Optional(2016-03-11 07:48:00 +0000) - shows 2 hours earlier, but works fine ^)
        let dateInDateFormat = dateFormatter.dateFromString(connectedDate)
        print("dateInDateFormat \(dateInDateFormat)")

        let dateNow = NSDate ()
        
//        if dateNow .timeIntervalSinceDate(dateInDateFormat!) > 0 {
//         HHAlertView .showAlertWithStyle(HHAlertStyle.Wraing, inView: self.view, title: "Reminder", detail: "Scheduled time already passed, please schedule actual time", cancelButton: nil, okbutton: "OK")
//        } else {
        
        let notification = UILocalNotification()
        notification.fireDate = dateInDateFormat
        notification.alertBody = notificationText as String
        notification.alertAction = "open"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "TODO_CATEGORY"
        
         UIApplication.sharedApplication().scheduleLocalNotification(notification)
             self.navigationController?.popViewControllerAnimated(true)
    //    }
    }
 
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    func dataPickerChanged (picker: UIDatePicker) {
   
        dateValue = dateformatter.stringFromDate(picker.date)
        
        settingsTable.reloadData()
        print("dateValue is: \(dateValue)")
    }
    

    // Table view methods @@@
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        
    let cell = settingsTable.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath!) as! settingsCell
      
      cell.mainLabel.text = settingsArray.objectAtIndex((indexPath?.row)!) as? String
        cell.settingsLabel.alpha = 0.5
        if indexPath!.row == 0 {
            
            if labelText == "" {
                labelText = "Place title here"
                cell.settingsLabel.text = labelText as? String
            } else {
            cell.settingsLabel.text = labelText as? String
            }
        }
        
        else  if indexPath!.row == 1 {
            
            if labelContent == "" {
                labelContent = "Content text"
                cell.settingsLabel.text = labelContent as? String
            } else {
                cell.settingsLabel.text = labelContent as? String
            }
        }  else if indexPath!.row == 2{
            if labelInteger != nil{
                cell.settingsLabel.text = remindArray.objectAtIndex(labelInteger!) as? String
            }
            
        }
            else if indexPath!.row == 3 {

                cell.settingsLabel.text = dateValue as String
            }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("Label1") as! LabelViewController
            
            vc.delegate = self
            vc.labelText = labelText
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        } else if indexPath.row == 1 {
            
            let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("Content1") as! TextViewViewController
            vc.delegate = self
            vc.labelContent = labelContent!
            
            self.presentViewController(vc, animated: true, completion: nil)

        } else if indexPath.row == 2 {
            
            let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("Before1") as! Notify_BeforeViewController
            
            vc.delegate = self
            vc.selectedIndex = labelInteger
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    
    }
    
    func updateLabelText(newLabel: String) {
        
        labelText = newLabel
        settingsTable.reloadData()
    }
    
    func updateLabelContent(newLabel: String) {
        labelContent = newLabel
        settingsTable.reloadData()
    }
    
    func updateLabelIndex(newIndex: Int){
        labelInteger = newIndex
        settingsTable.reloadData()
        print("updateLabelIndex CALLEd")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}