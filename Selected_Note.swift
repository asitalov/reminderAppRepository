//
//  Selected_Note.swift
//  SAReminder
//
//  Created by Alexei Sitalov on 3/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData

var selectedIndex : Int?
var selectedIndexPath : NSIndexPath?

class Selected_Note: UIViewController, NSFetchedResultsControllerDelegate, HHAlertViewDelegate {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let request = NSFetchRequest(entityName: "Notes")
    let alertVC = HHAlertView()

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
  
    
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

    @IBAction func settingsButtonPressed(sender: AnyObject) {
        
        view.backgroundColor = UIColor.grayColor()
        
        let button: UIButton = (sender as! UIButton)
        PCStackMenu.showStackMenuWithTitles(["Setting", "Search", "Twitter", "Message", "Share", "More ..."], withImages: [UIImage(named: "gear@2x.png")!, UIImage(named: "magnifier@2x.png")!, UIImage(named: "twitter@2x.png")!, UIImage(named: "speech@2x.png")!, UIImage(named: "actions@2x")!], atStartPoint: CGPointMake(button.frame.origin.x + button.frame.size.width, button.frame.origin.y), inView: self.view!, itemHeight: 40, menuDirection: PCStackMenuDirectionClockWiseUp, onSelectMenu: {(selectedMenuIndex: Int) -> Void in
           NSLog("menu index : %d", Int(selectedMenuIndex))
            if selectedMenuIndex == 4 {
                print ("index 1 pressed")
               
            }
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
         self.view.backgroundColor = UIColor(patternImage: UIImage(named: "i5backgroundImage.jpg")!)
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "notePad2@2x.jpg")!)
      //  settingsButton.image = UIImage(named: "settings.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
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
        let contentText = notes.contentText
       
        titleLabel.text = title
        dateLabel.text = alarmText
        myImage.image = UIImage(named: imageSelected!)
        textLabel.text = contentText
        
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
            
            do {
                try notes.managedObjectContext!.save()
            } catch {
                print(error)
            }
            
            self.navigationController?.popViewControllerAnimated(true)
         
    } else if indexPath.row == 1 {
            
             HHAlertView .showAlertWithStyle(HHAlertStyle.Wraing, inView: self.view, title: "Warning", detail: "Current action will delete current data. Continue?", cancelButton: "NO", okbutton: "YES")
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
