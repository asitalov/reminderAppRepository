//
//  Notify_BeforeViewController.swift
//  SAReminder
//
//  Created by Alexei Sitalov on 3/14/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class Notify_BeforeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var notifyBeforeValues = NSArray()
    var checkedIndexPath: NSIndexPath?
    var tappedIndexPath2: Int?
    var selectedIndex: Int?
    var delegate: newNote?
    let theNewNote = New_Note ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: GetBackgroundImage.getImage())        
        notifyBeforeValues = ["dont remind", "5 minutes", "10 minutes", "15 minutes", "30 minutes", "1 hour", "2 hours", "1 day"]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func returnToPreviousView(sender: AnyObject) {
        
        if delegate != nil && tappedIndexPath2 != nil {
            delegate!.updateLabelIndex(tappedIndexPath2!)
            presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        } else {
            
            //theNewNote.labelInteger = tappedIndexPath2
            
            presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        print ("select index is \(selectedIndex)")
        //   contentTextView.text = labelContent as? String  WILL PUT CHECKMARK
        
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
        
        return notifyBeforeValues.count
    }
    
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as UITableViewCell
        
        cell.textLabel?.text = notifyBeforeValues.objectAtIndex((indexPath?.row)!) as? String
        cell.backgroundColor = UIColor.clearColor() 
        if indexPath!.row == selectedIndex
        {
            cell.accessoryType = .Checkmark;
        }
        else
        {
            cell.accessoryType = .None;
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
        
        if (selectedIndex != nil){
            let newIndexPath = NSIndexPath(forRow:selectedIndex!, inSection: 0)
            let uncheckCell: UITableViewCell = tableView.cellForRowAtIndexPath(newIndexPath)!
            uncheckCell.accessoryType = .None
        }
        
        if (checkedIndexPath != nil) {
            let uncheckCell: UITableViewCell = tableView.cellForRowAtIndexPath(self.checkedIndexPath!)!
            uncheckCell.accessoryType = .None
            checkedIndexPath = nil
            tappedIndexPath2 = nil
        }
        
        if ((checkedIndexPath?.isEqual(indexPath)) != nil) {
            
        }
        else {
            let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.accessoryType = .Checkmark
            self.checkedIndexPath = indexPath
            tappedIndexPath2 = indexPath.row
        }
        print(tappedIndexPath2)
        
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
