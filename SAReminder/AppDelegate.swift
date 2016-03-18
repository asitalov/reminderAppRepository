//
//  AppDelegate.swift
//  SAReminder
//
//  Created by Admin on 09.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var myNewDictArray = NSMutableArray ()
    var indexInteger: Int?
    let userDefaults = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        myNewDictArray = userDefaults.mutableArrayValueForKey("alarmArr")
        
        // creating initial userdefaults uiswitch value

        application.registerUserNotificationSettings(UIUserNotificationSettings (forTypes: UIUserNotificationType.Alert, categories: nil))
        
        
            return true
    }
    
    func callGesturePassword () {
        
        if (userDefaults.objectForKey("gesturePassword") != nil && userDefaults.objectForKey("password")?.boolValue == true ) {
            let controller: YLCheckToUnlockViewController = YLCheckToUnlockViewController()
           // self.presentViewController(controller, animated: true, completion: { _ in })
            self.window?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
        }
        //        else {
        //            let alert: UIAlertView = UIAlertView(title: "Attention", message: "no gesture password set", delegate: nil, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        //            alert.show()
        //        }
        
    }

    func applicationWillResignActive(application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        if userDefaults.objectForKey("password") == nil{
            userDefaults.setBool(false, forKey: "password")
        }
        
        if userDefaults.objectForKey("switch") == nil {
            userDefaults.setBool(false, forKey: "switch")
        }
        
        self.callGesturePassword()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

