//
//  ViewController.swift
//  SAReminder
//
//  Created by Admin on 09.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
  
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var todoSearchBar: UISearchBar!
    @IBOutlet weak var alarmTable: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let selectNote = Selected_Note()
    let createANote = New_Note()
    var messageLabel = UILabel()
    var searchArray = NSMutableArray()
    var isFiltered: Bool?
    let revealView = SWRevealViewController ()
    let formatter1 = NSDateFormatter ()
    let formatter2 = NSDateFormatter ()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let request = NSFetchRequest(entityName: "Notes")
    @IBOutlet weak var myImage: UIImageView!
    let currentDateFormatter = NSDateFormatter ()

    
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

        return frc
    }()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "createNote") {
            let newNoteVC: New_Note = segue.destinationViewController as! New_Note
            newNoteVC.titleText = "Add a note"
            selectedIndexPath2 = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Reminder"
        
        messageLabel = UILabel(frame: CGRectMake(0, 0, 200, 84))
        messageLabel.numberOfLines = 4
        currentDateFormatter.dateFormat = "d MMM, YYYY"
        
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.text = "You don't have any notes. To add a new note click '+' button"

        self.view.backgroundColor = UIColor(patternImage: GetBackgroundImage.getImage())
        view.addSubview(messageLabel)

        leftBarButton.target = revealView.revealViewController()
        leftBarButton.action = "revealToggle:"
        self.view!.addGestureRecognizer(revealView.panGestureRecognizer())
        
        formatter1.timeStyle =  NSDateFormatterStyle.ShortStyle
        formatter1.dateFormat = "MM.dd hh:mm"
        
        formatter2.timeStyle = NSDateFormatterStyle.MediumStyle
        formatter2.dateFormat = "MMM dd,  hh:mm"
        let theDate = NSDate()
        let theDateString = currentDateFormatter.stringFromDate(theDate)
        dateLabel.text = theDateString
        
        self.tabBarController?.tabBar.backgroundImage = UIImage(named: "tabbar")

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNotification:", name: "MyNotification", object: nil)

    }

    
    override func viewDidLayoutSubviews() {
        messageLabel.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return 1
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
   
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {

        let cell = alarmTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as! Cell
        cell.accessoryView = UIImageView(image: UIImage(named: "discIndicator.png"))
        cell.backgroundColor = UIColor.clearColor()
        let notes = fetchedResultsController.objectAtIndexPath(indexPath!) as! Notes
        
        let imageSelected = notes.buttonName
        let alarmText = notes.date
        let statusImage = notes.status

        let dateInDateFormat = formatter1.dateFromString(alarmText!)
        let dateInStringFormat = formatter2.stringFromDate(dateInDateFormat!)
      
        cell.titleLabel?.text = notes.titleText
        if imageSelected != "" {
        cell.myImage.image = UIImage(named: imageSelected!)
        }
        cell.alarmLabel?.text = dateInStringFormat
        
        if statusImage != "" && statusImage != nil{
        cell.statusImage.image = UIImage(named:statusImage!)
        cell.backgroundColor = UIColor(red: (160.0 / 255.0), green: (160.0 / 255.0), blue: (160.0 / 255.0), alpha: 0.5)
        }

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndex = indexPath.row
        selectedIndexPath = indexPath
        
    }
    
    func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        self.navigationItem.title = "Delete Remindings"
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        self.navigationItem.title = "Reminder"
    }
    
    // добавляем в том случае, если таблица была перетянута как утилита
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.alarmTable.setEditing(editing, animated: animated)
    }
    
    func setDateFormat(){
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM.dd hh:mm"
        
    }
  
    
  func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                
            let notes = fetchedResultsController.objectAtIndexPath(indexPath) as! Notes
            
            let userInfo = ["url" : "www.mobiwise.co"]
            LocalNotificationHelper.sharedInstance().cancelNotificationWithKey("mobiwise", title: "view details", message: notes.titleText!, date: notes.dateInDateFormat!, userInfo: userInfo)
            LocalNotificationHelper.sharedInstance().cancelNotificationWithKey("mobiwise", title: "view details", message: notes.titleText!, date: notes.someTimeBefore!, userInfo: userInfo)
            
            managedObjectContext.deleteObject(notes)
            
                do {
                    try notes.managedObjectContext!.save()
                } catch {
                    print(error)
                }
            
               self.alarmTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            let notesFetchRequest = NSFetchRequest(entityName: "Notes")
            
            let count = managedObjectContext.countForFetchRequest(notesFetchRequest, error: nil)
            
            if count == 0
            {
                addAnEmptyView()
                todoSearchBar.userInteractionEnabled = false
                }
                
            default:
                return
            }
    }
    
    func filter(text: String) {
        if text != "" {
            let predicate: NSPredicate = NSPredicate(format: "(titleText CONTAINS[c] %@) OR (date CONTAINS[c] %@)", text, text)
            fetchedResultsController.fetchRequest.predicate = predicate
        } else {
            fetchedResultsController.fetchRequest.predicate = nil
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
            
        }
    }
    
   
    func searchBar(searchBar: UISearchBar, textDidChange text: String) {
        
        self.filter(text)
          alarmTable.reloadData()
        }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        todoSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        todoSearchBar.resignFirstResponder()
        todoSearchBar.text = nil
        todoSearchBar.setShowsCancelButton(false, animated: true)
       fetchedResultsController.fetchRequest.predicate = nil
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
        
        alarmTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        todoSearchBar.resignFirstResponder()
        todoSearchBar.setShowsCancelButton(false, animated: true)
    }
    
    func removeAnEmptyView(){
        
        alarmTable.hidden = false
        messageLabel.hidden = true
   
    }
    
    
    func addAnEmptyView(){
        
        alarmTable.hidden = true
        messageLabel.hidden = false
      
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        let notesFetchRequest = NSFetchRequest(entityName: "Notes")
        
        let count = managedObjectContext.countForFetchRequest(notesFetchRequest, error: nil)
        
        if count == 0
        {
            addAnEmptyView()
            todoSearchBar.userInteractionEnabled = false
        } else {
            removeAnEmptyView()
             todoSearchBar.userInteractionEnabled = true
        }
        alarmTable.reloadData()
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        if type != .Delete {
         alarmTable.reloadData()
        }
    }
    
    func performSearch(date: NSDate) {
        
        let predicate: NSPredicate = NSPredicate(format:"searchDate == %@", date)
        fetchedResultsController.fetchRequest.predicate = predicate
                
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
            
        }
        
    }
    
    func handleNotification(notification: NSNotification) {
        performSearch(notification.userInfo?["searchDate"] as! NSDate)
    }

}

