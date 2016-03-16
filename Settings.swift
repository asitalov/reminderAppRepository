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
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        self.view.backgroundColor = UIColor(red: (232.0 / 255.0), green: (166.0 / 255.0), blue: (105.0 / 255.0), alpha: 1.0)
     
        leftBarButton.target = revealView.revealViewController()
        leftBarButton.action = "revealToggle:"
        self.view!.addGestureRecognizer(revealView.panGestureRecognizer())
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
