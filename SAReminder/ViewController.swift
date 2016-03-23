//
//  ViewController.swift
//  SAReminder
//
//  Created by Admin on 09.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData

protocol myProtocol {
     func changeMyProtocol()
}

class ViewController: UIViewController, UITableViewDelegate, buttonsChange, NSFetchedResultsControllerDelegate {
    
    func selectChildButton() {
        
    }
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var todoSearchBar: UISearchBar!
    @IBOutlet weak var alarmTable: UITableView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let selectNote = Selected_Note()
    let createANote = New_Note()
    var messageLabel = UILabel()
    var searchArray = NSMutableArray()
    var isFiltered: Bool?
    let revealView = SWRevealViewController ()
    let formatter1 = NSDateFormatter ()
    let formatter2 = NSDateFormatter ()
   // var fetchedResultsController: NSFetchedResultsController!
    var delegate:buttonsChange?
    var token: dispatch_once_t = 0
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let request = NSFetchRequest(entityName: "Notes")
    @IBOutlet weak var myImage: UIImageView!
    

    @IBAction func addObject(sender: UIButton) {

        delegate?.selectChildButton()
        
    }
    
  
    
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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        let controller = segue.destinationViewController as! New_Note
//        
//        controller.selectChildButton()
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Reminder"
    
        messageLabel = UILabel(frame: CGRectMake(0, 0, 200, 84))
        messageLabel.numberOfLines = 4
        
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.text = "You don't have any notes. To add a new note click '+' button"

        view.backgroundColor = UIColor .groupTableViewBackgroundColor()
        view.addSubview(messageLabel)
        alarmTable.backgroundColor = UIColor.groupTableViewBackgroundColor()// UIColor(red: (232.0 / 255.0), green: (166.0 / 255.0), blue: (105.0 / 255.0), alpha: 1.0)
        leftBarButton.target = revealView.revealViewController()
        leftBarButton.action = "revealToggle:"
        self.view!.addGestureRecognizer(revealView.panGestureRecognizer())
        
        formatter1.timeStyle =  NSDateFormatterStyle.ShortStyle
        formatter1.dateFormat = "MM.dd hh:mm"
        
        formatter2.timeStyle = NSDateFormatterStyle.MediumStyle
        formatter2.dateFormat = "MMM dd,  hh:mm"
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
            
        }
    }

    
    override func viewDidLayoutSubviews() {
        messageLabel.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        if isFiltered == true {
//            return searchArray.count;
//        }
//        return appDelegate.myNewDictArray.count;
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
//        let cell:UITableViewCell = self.alarmTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as UITableViewCell
        
        let cell = alarmTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as! Cell
        cell.accessoryType = .DisclosureIndicator
        
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
        cell.alarmLabel?.text = dateInStringFormat//notes.date
        if statusImage != nil{
        cell.statusImage.image = UIImage(named:statusImage!)
        }
        
//        if appDelegate.myNewDictArray.count > 0 {
//           
//        let noteText = appDelegate.myNewDictArray.objectAtIndex((indexPath?.row)!) .objectForKey("text") as! String
//        var alarmText = appDelegate.myNewDictArray.objectAtIndex((indexPath?.row)!) .objectForKey("date") as! String
//           
//            let dateInDateFormat = formatter1.dateFromString(alarmText)
//            let dateInStringFormat = formatter2.stringFromDate(dateInDateFormat!)
//            
//            let imageSelected = appDelegate.myNewDictArray.objectAtIndex((indexPath?.row)!).objectForKey("image") as! String
//            
//            alarmText = dateInStringFormat
//          
//           if (isFiltered == nil) {
//            
//                // Configure the cell...
//                cell.titleLabel.text = noteText as String
//                cell.alarmLabel.text = alarmText
//                cell.myImage.image = UIImage(named: imageSelected)
//            }
//            
//            else {
//            
//                //  Configue the cell with filtered results.
//                cell.titleLabel.text = searchArray.objectAtIndex((indexPath?.row)!).objectForKey("text") as? String
//                cell.alarmLabel.text = searchArray.objectAtIndex((indexPath?.row)!).objectForKey("date") as? String
//            }
//
//        } else {
//            
//        }
        
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
    
  func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                
            let notes = fetchedResultsController.objectAtIndexPath(indexPath) as! Notes
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
 
    func searchBar(searchBar: UISearchBar, textDidChange text: String) {
        
        if text == "" {
        
            isFiltered = nil
        
        }
            
        else {

            self.isFiltered = true
            
            searchArray.removeAllObjects()
            searchArray.addObjectsFromArray(appDelegate.myNewDictArray.filteredArrayUsingPredicate(NSPredicate(format: "(text CONTAINS[cd] %@) OR (date CONTAINS[cd] %@)", text, text)))

        }
        
        if text.characters.count == 1 && searchArray.count == 0 {
            searchBar.resignFirstResponder()
        searchArray.addObjectsFromArray(appDelegate.myNewDictArray as [AnyObject])
        }
        
        print ("count == \(searchArray.count)")
          alarmTable.reloadData()
        
        }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        var resultRange: NSRange = text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet(), options: NSBackwardsSearch)
//        if text.characters.count == 1 && searchArray.count == 0 {
//            searchBar.resignFirstResponder()
//            return false
//        }
        
        return true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        todoSearchBar.resignFirstResponder()
    }
    
    func dismissKeyBoard () {
    todoSearchBar.resignFirstResponder()
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
            
        }
        alarmTable.reloadData()
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        if type != .Delete {
         alarmTable.reloadData()
        }
    }
}

