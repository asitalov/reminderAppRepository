//
//  Settings.swift
//  SAReminder
//
//  Created by Alexei Sitalov on 3/16/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class Settings: UIViewController {
    
let revealView = SWRevealViewController ()
    
    var settingsArray = NSArray ()
    var mySwitch = UISwitch()
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        settingsArray = ["Set gesure password", "Gesture password active"]
        self.view.backgroundColor = UIColor(red: (232.0 / 255.0), green: (166.0 / 255.0), blue: (105.0 / 255.0), alpha: 1.0)
        self.tableView.backgroundColor = UIColor(red: (232.0 / 255.0), green: (166.0 / 255.0), blue: (105.0 / 255.0), alpha: 1.0)
        leftBarButton.target = revealView.revealViewController()
        leftBarButton.action = "revealToggle:"
        self.view!.addGestureRecognizer(revealView.panGestureRecognizer())
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeSwitch(sender: AnyObject) {
        
        if mySwitch.on {
            print("Switch is ON")
            userDefaults.setBool(true, forKey: "password")
             userDefaults.setBool(true, forKey: "switch")
        }
        else {
            print("Switch is OFF")
            userDefaults.setBool(false, forKey: "password")
             userDefaults.setBool(false, forKey: "switch")

        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
    
        return settingsArray.count    //appDelegate.myNewDictArray.count;
    }
    
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as UITableViewCell
        cell.textLabel?.text = settingsArray.objectAtIndex((indexPath?.row)!) as? String
        cell.backgroundColor = UIColor.groupTableViewBackgroundColor()//UIColor(red: (152.0 / 255.0), green: (116.0 / 255.0), blue: (105.0 / 255.0), alpha: 1.0)

        if indexPath!.row == 0 {
            cell.accessoryType = .DisclosureIndicator
        } else if indexPath!.row == 1 {
            
            mySwitch = UISwitch(frame:CGRectMake(150, 300, 0, 0));
            
            if userDefaults.objectForKey("switch")?.boolValue == false {
                mySwitch.on = false
              
            } else {
                mySwitch.on = true
               
            }

            mySwitch.addTarget(self, action: "changeSwitch:", forControlEvents: .ValueChanged)

            cell.accessoryView = mySwitch
           
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        if indexPath.row == 0 {
            let controller: YLInitSwipePasswordController = YLInitSwipePasswordController()
            self.presentViewController(controller, animated: true, completion: { _ in })

        } 
        
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
