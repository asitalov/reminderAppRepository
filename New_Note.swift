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
    var notificationText = String()
    var settingsArray = NSArray()
    var remindArray = NSArray()
    var labelText:String?
    var labelContent:NSString?
    var labelInteger:Int?
    var imageNameText:NSString?
    var delegate: newNote?
    var titleText:String?
    var dateInDateFormat:NSDate?

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var childButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!

    let alertVC = HHAlertView()
   
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
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
       self.view.backgroundColor = UIColor(patternImage: GetBackgroundImage.getImage())

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
            
            self.checkButtonName()
            
        } else {
            childButton.selected = true
            childButton.setImage(UIImage(named: "child-selected.png"), forState: .Selected)
            
            labelText = "Place title here"
            labelContent = "Content text"
            labelInteger = 0
        }
     
        self.title = titleText

        settingsArray = ["Title", "Content", "Remind before", "Alarm"]
        remindArray = ["dont remind", "5 mins", "10 mins", "15 mins", "30 mins", "1 hour", "2 hours", "1 day"]
        
      //  HHAlertView.shared().delegate = self

        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.dateFormat="MM.dd hh:mm"
        
        dateValue = dateformatter.stringFromDate(picker.date)

        picker.addTarget(self, action: Selector("dataPickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)

    }

    
    func checkButtonName() {
        
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
    
  func getImage() -> NSString {
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
        return image
    }
    
    
    @IBAction func saveChanges(sender: UIBarButtonItem) {
        
      if labelText == "Place title here"{
        HHAlertView .showAlertWithStyle(HHAlertStyle.Wraing, inView: self.view, title: "Reminder", detail: "Please add a message for notification", cancelButton: nil, okbutton: "OK")
        
      } else {
        
        let myImage = getImage()
        
        let dateNow = NSDate ()
        
        if dateNow .timeIntervalSinceDate(picker.date) > 0 {
            HHAlertView .showAlertWithStyle(HHAlertStyle.Wraing, inView: self.view, title: "Reminder", detail: "Scheduled time already passed, please schedule actual time", cancelButton: nil, okbutton: "OK")
        } else {

        scheduleNotification(Remind_Before.truncateSecondsForDate(picker.date))
            
            
        // CoreData
        if selectedIndexPath2 != nil {
            
            let notes = fetchedResultsController.objectAtIndexPath(selectedIndexPath2!) as! Notes
            
            notes.setValue(labelText, forKey: "titleText")
            notes.setValue(dateValue, forKey: "date")
            notes.setValue(myImage, forKey: "buttonName")
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
        nextNote.setValue(myImage, forKey: "buttonName")
        nextNote.setValue(labelContent, forKey: "contentText")
        nextNote.setValue(Remind_Before.truncateSecondsForDate(picker.date), forKey: "dateInDateFormat")
        
        let castAsNSNumber = NSNumber(integer: labelInteger!)
        
        nextNote.setValue(castAsNSNumber, forKey: "index")
            
            let someTimeBefore: NSDate = NSCalendar.currentCalendar().dateByAddingComponents(Remind_Before.scheduleBefore(labelInteger!), toDate: Remind_Before.truncateSecondsForDate(picker.date), options: [])!
            
            scheduleNotification(someTimeBefore)
            
             nextNote.setValue(someTimeBefore, forKey: "someTimeBefore")
            
        do {
            try nextNote.managedObjectContext!.save()
        } catch {
            print(error)
        }
        }
            }
        }
    
    }
    
    func scheduleNotification (date: NSDate) {
        
        let userInfo = ["url" : "www.mobiwise.co"]
        LocalNotificationHelper.sharedInstance().scheduleNotificationWithKey("mobiwise", title: "view details", message: labelText!, date: date, userInfo: userInfo)
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func dataPickerChanged (picker: UIDatePicker) {
   
        dateValue = dateformatter.stringFromDate(picker.date)
        
        settingsTable.reloadData()
        print("dateValue is: \(dateValue)")
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        
    let cell = settingsTable.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath!) as! settingsCell
      cell.selectionStyle = .None//UITableViewCellSelectionStyleGray
      cell.mainLabel.text = settingsArray.objectAtIndex((indexPath?.row)!) as? String
        cell.backgroundColor = UIColor.clearColor()
        cell.settingsLabel.alpha = 0.5
   
       
        cell.accessoryView = UIImageView(image: UIImage(named: "discIndicator.png"))

        if indexPath!.row == 0 {
            
            if labelText == "" {
                labelText = "Place title here"
                cell.settingsLabel.text = labelText
            } else {
            cell.settingsLabel.text = labelText
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
            cell.accessoryView = .None
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
        
//        self.picker.locale = NSLocale.currentLocale()
        self.picker.timeZone = NSTimeZone.defaultTimeZone()
    
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