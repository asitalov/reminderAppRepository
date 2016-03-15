//
//  ViewController.swift
//  SAReminder
//
//  Created by Admin on 09.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var alarmTable: UITableView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let selectNote = Selected_Note()
    var messageLabel = UILabel()
    
    @IBOutlet weak var shareButton: UIButton!
    
  
    
    @IBOutlet weak var calendarImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Reminder"
    
        messageLabel = UILabel(frame: CGRectMake(0, 0, 200, 84))
        messageLabel.numberOfLines = 4
        
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.text = "You don't have any notes. To add a new note click '+' button"

        //alarmTable.hidden = true
        view.backgroundColor = UIColor .groupTableViewBackgroundColor()
        view.addSubview(messageLabel)

    }


    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
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
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.myNewDictArray.count
    }
    
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
//        let cell:UITableViewCell = self.alarmTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as UITableViewCell
        
        let cell = alarmTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as! Cell
        
        if appDelegate.myNewDictArray.count > 0 {
        let noteText = appDelegate.myNewDictArray.objectAtIndex((indexPath?.row)!) .objectForKey("text")
        let alarmText = appDelegate.myNewDictArray.objectAtIndex((indexPath?.row)!) .objectForKey("date")
       
         cell.titleLabel.text = noteText as? String
         cell.alarmLabel.text = alarmText as? String
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndex = indexPath.row
        
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
                // remove the deleted item from the model
                appDelegate.myNewDictArray.removeObjectAtIndex(indexPath.row)

                
                // remove the deleted item from the `UITableView`
               self.alarmTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                if appDelegate.myNewDictArray.count == 0 {
                    addAnEmptyView()
                }
            default:
                return
            }
    }
    
    func removeAnEmptyView(){
        
        alarmTable.hidden = false
        messageLabel.hidden = true
        calendarImage.hidden = true
    }
    
    
    func addAnEmptyView(){
        
        alarmTable.hidden = true
        messageLabel.hidden = false
        calendarImage.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        if appDelegate.myNewDictArray.count == 0 {
        alarmTable.reloadData()
            addAnEmptyView()
        } else {
            removeAnEmptyView()
            alarmTable.reloadData()
        }
    }
}

