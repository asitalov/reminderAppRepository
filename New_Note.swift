//
//  New_Note.swift
//  SAReminder
//
//  Created by Admin on 09.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData

protocol newNote {
    
     func updateLabelText(newLabel: String)
     func updateLabelContent(newLabel: String)
     func updateLabelIndex(newIndex: Int)
    

}

protocol buttonsChange {
    func selectChildButton ()
}

class New_Note: UIViewController, UITextViewDelegate, HHAlertViewDelegate, UITableViewDelegate, newNote {
    
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
    var delegate: newNote?

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var childButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!

    let alertVC = HHAlertView() //objective c class

     let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(managedObjectContext)
        self.title = "Add notification"
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.picker.backgroundColor = UIColor.whiteColor()
        settingsArray = ["Title", "Content", "Remind before", "Alarm"]
        remindArray = ["dont remind", "5 mins", "10 mins", "15 mins", "30 mins", "1 hour", "2 hours", "1 day"]
        
        HHAlertView.shared().delegate = self

        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.dateFormat="MM.dd hh:mm"
        
        dateValue = dateformatter.stringFromDate(picker.date)

        picker.addTarget(self, action: Selector("dataPickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        labelText = "Place title here"
        labelContent = "Content text"
        labelInteger = 0

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
    
    func didClickButtonAnIndex(button: HHAlertButton) {
        if button == HHAlertButton.Ok{
            print("OK TOUCHED")
        }
    }
    

    
    @IBAction func Save(sender: UIBarButtonItem) {
        
      if labelText == "Place title here"{
        HHAlertView .showAlertWithStyle(HHAlertStyle.Wraing, inView: self.view, title: "Reminder", detail: "Please add a message for notification", cancelButton: nil, okbutton: "OK")
        
      } else {
 
        if labelContent != nil && labelContent != "Content here"{
          dict.setObject(labelContent!, forKey: "content")
        }
        
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

        dict .setObject(labelText!, forKey: "text")
        dict .setObject(dateValue, forKey: "date")
        dict .setObject(image, forKey: "image")
        print(dict.objectForKey("text"))
        
        // CoreData
        
        let notes =  NSEntityDescription.entityForName("Notes",
            inManagedObjectContext:managedObjectContext)
        let nextNote = NSManagedObject(entity: notes!, insertIntoManagedObjectContext: self.managedObjectContext)
    
        nextNote.setValue(labelText, forKey: "titleText")
        nextNote.setValue(dateValue, forKey: "date")
        nextNote.setValue(image, forKey: "buttonName")
        nextNote.setValue(labelContent, forKey: "contentText")
//        nextNote.setValue(labelContent, forKey: "contentName")
        
        print("nextNote == \(nextNote)")
      
        do {
            try nextNote.managedObjectContext!.save()
        } catch {
            print(error)
        }
        //notes?.setValue(labelText, forKey: "titleText")
       
        //@@@
        
        appDelegate.myNewDictArray .addObject(dict)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(appDelegate.myNewDictArray as Array, forKey: "alarmArr")
        
        scheduleNotification()
        
        HHAlertView .showAlertWithStyle(HHAlertStyle.Ok, inView: self.view, title: "Success", detail: "Notification created", cancelButton: nil, okbutton: nil)

        delay(1.5) {
            self.navigationController?.popViewControllerAnimated(true)
        }
        }
    }
    
    func scheduleNotification () {
        
        let currentDate = NSDate ()
        
        let dateFormatter = NSDateFormatter()
        let dateFormatter2 = NSDateFormatter()
        
        dateFormatter.dateFormat = "YYYY.MM.dd hh:mm"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT +2:00")
        
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

        
        let notification = UILocalNotification()
        notification.fireDate = dateInDateFormat
        notification.alertBody = notificationText as String
        notification.alertAction = "open"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "TODO_CATEGORY"
        
         UIApplication.sharedApplication().scheduleLocalNotification(notification)
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
    
    func greenTouched(sender: UIButton) {
        
    }
    
    
    func orangeTouched(sender: UIButton){
        
    }
    
    
    func redTouched(sender: UIButton){
        
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
    
    func selectChildButton (){
        
//         childButton.selected = true
        print ("child button selected")
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