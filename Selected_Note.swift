//
//  Selected_Note.swift
//  SAReminder
//
//  Created by Alexei Sitalov on 3/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

var selectedIndex : Int = 0


class Selected_Note: UIViewController {

    @IBOutlet weak var textLabel: UILabel!    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
  
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        
        view.backgroundColor = UIColor.grayColor()
        
        let button: UIButton = (sender as! UIButton)
        PCStackMenu.showStackMenuWithTitles(["Setting", "Search", "Twitter", "Message", "Share", "More ..."], withImages: [UIImage(named: "gear@2x.png")!, UIImage(named: "magnifier@2x.png")!, UIImage(named: "twitter@2x.png")!, UIImage(named: "speech@2x.png")!, UIImage(named: "actions@2x")!], atStartPoint: CGPointMake(button.frame.origin.x + button.frame.size.width, button.frame.origin.y), inView: self.view!, itemHeight: 40, menuDirection: PCStackMenuDirectionClockWiseUp, onSelectMenu: {(selectedMenuIndex: Int) -> Void in
           NSLog("menu index : %d", Int(selectedMenuIndex))
            if selectedMenuIndex == 4 {
                print ("index 1 pressed")
               
            }
        })
//view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
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
        
        let textForContentLabel = appDelegate.myNewDictArray.objectAtIndex((selectedIndex)) .objectForKey("text")
        let textForDateLabel = appDelegate.myNewDictArray.objectAtIndex((selectedIndex)) .objectForKey("date")
        
        textLabel.text = textForContentLabel as? String
        dateLabel.text = textForDateLabel as? String
        
    }

    @IBAction func removeNote(sender: UIButton) {
        
        appDelegate.myNewDictArray .removeObjectAtIndex(selectedIndex)
        navigationController?.popViewControllerAnimated(true)
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
