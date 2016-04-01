//
//  Selected_Note.swift
//  SAReminder
//
//  Created by Alexei Sitalov on 3/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData
import Social

var selectedIndex : Int?
var selectedIndexPath : NSIndexPath?

class Selected_Note: UIViewController, NSFetchedResultsControllerDelegate, HHAlertViewDelegate {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let request = NSFetchRequest(entityName: "Notes")
    let alertVC = HHAlertView()
   // var mySLComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
    var viewScreen = UIImage ()

    
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
     @IBOutlet weak var reminderLabel: UILabel!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
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
    
    func showAlertViewWithTitle(title: String, andMessage message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction) -> Void in
        })
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: { _ in })
    }
    
    func captureScreenshot() -> UIImage {
        self.reminderLabel.hidden = false
        UIGraphicsBeginImageContext(self.view.bounds.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        viewScreen = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //  UIImageWriteToSavedPhotosAlbum(imageView, nil, nil, nil);
        return viewScreen
    }
    
    func shareOnPublic (serviceType:String, message:String){
        
        var mySLComposerSheet = SLComposeViewController(forServiceType: serviceType)
        
        if SLComposeViewController.isAvailableForServiceType(serviceType) {
            mySLComposerSheet = SLComposeViewController()
            mySLComposerSheet = SLComposeViewController(forServiceType: serviceType)
            mySLComposerSheet.setInitialText("Paste any text or links(could be your app link) here")
            self.captureScreenshot ()
            mySLComposerSheet.addImage(self.viewScreen)
            self.reminderLabel.hidden = true
            self.presentViewController(mySLComposerSheet, animated: true, completion: { _ in })
        }
        else {
            
            let message: String = message //String = "You need to add your facebook profile in the phone settings"
            self.showAlertViewWithTitle("Oops", andMessage: message)
        }

    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let FBAction = UIAlertAction(title: "Share on Facebook", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in

            self.shareOnPublic (SLServiceTypeFacebook, message:"You need to add your facebook profile in the phone settings")
            
        })
        
        let TwitterAction = UIAlertAction(title: "Share on Twitter", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in

            self.shareOnPublic (SLServiceTypeTwitter, message:"You need to add your twitter profile in the phone settings")
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })

        optionMenu.addAction(FBAction)
        optionMenu.addAction(TwitterAction)
        optionMenu.addAction(cancelAction)

        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: GetBackgroundImage.getImage())
        titleLabel.layer.cornerRadius = 5
        titleLabel.backgroundColor = UIColor(red: 255, green: 247, blue: 220, alpha: 0.5)
        titleLabel.layer.masksToBounds = true
        contentText.layer.cornerRadius = 5
        contentText.backgroundColor = UIColor(red: 255, green: 247, blue: 220, alpha:1)
        contentText.layer.masksToBounds = true
        
        self.reminderLabel.hidden = true
        
        dateLabel.backgroundColor = UIColor(red: 255, green: 247, blue: 220, alpha: 0.5)
        dateLabel.layer.cornerRadius = 5
        dateLabel.layer.masksToBounds = true
        
        self.tabBarController?.tabBar.hidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.tableView.reloadData()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
       
        HHAlertView.shared().delegate = self
        
        let notes = fetchedResultsController.objectAtIndexPath(selectedIndexPath!) as! Notes
        
        let title = notes.titleText
        let imageSelected = notes.buttonName
        let alarmText = notes.date
        let contentText1 = notes.contentText
       
        titleLabel.text = title
        dateLabel.text = alarmText
        myImage.image = UIImage(named: imageSelected!)
        contentText.text = contentText1
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {

        return 2
    }
    
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
     // let cell:UITableViewCell = tableView!.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as UITableViewCell
       let cell = tableView!.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as! CellSelected
        let notes = fetchedResultsController.objectAtIndexPath(selectedIndexPath!) as! Notes
         cell.backgroundColor = UIColor.clearColor()
        if indexPath!.row == 0 {
            if notes.status == "completed_stamp.gif" {
            cell.titleLabel.text = "Note is completed"
                //cell.backgroundColor = UIColor.lightGrayColor()
                cell.userInteractionEnabled = false
            } else {
        cell.titleLabel.text = "Mark as completed"
            }
        } else if indexPath!.row == 1 {
          cell.titleLabel.text = "Delete"
            cell.titleLabel.textColor = UIColor.redColor()

        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0{
            
          let notes = fetchedResultsController.objectAtIndexPath(selectedIndexPath!) as! Notes
          notes.status = "completed_stamp.gif"
            let userInfo = ["url" : "www.mobiwise.co"]
            LocalNotificationHelper.sharedInstance().cancelNotificationWithKey("mobiwise", title: "view details", message: notes.titleText!, date: notes.dateInDateFormat!, userInfo: userInfo)
            LocalNotificationHelper.sharedInstance().cancelNotificationWithKey("mobiwise", title: "view details", message: notes.titleText!, date: notes.someTimeBefore!, userInfo: userInfo)
            do {
                try notes.managedObjectContext!.save()
            } catch {
                print(error)
            }
            
            self.navigationController?.popViewControllerAnimated(true)
         
    } else if indexPath.row == 1 {
            
             HHAlertView .showAlertWithStyle(HHAlertStyle.Wraing, inView: self.view, title: "Warning", detail: "This action will remove current data. Continue?", cancelButton: "NO", okbutton: "YES")
        }
        
    }

    func didClickButtonAnIndex(button: HHAlertButton) {
        
        if button == HHAlertButton.Ok {
            
            let notes = fetchedResultsController.objectAtIndexPath(selectedIndexPath!) as! Notes
            managedObjectContext.deleteObject(notes)
            
            do {
                try notes.managedObjectContext!.save()
            } catch {
                print(error)
            }
            self.navigationController?.popViewControllerAnimated(true)

        }
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editNote") {
        selectedIndexPath2 = selectedIndexPath
            let correctNoteVC: New_Note = segue.destinationViewController as! New_Note
            correctNoteVC.titleText = "Edit"
        }
    }

}
