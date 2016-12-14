//
//  GetBackgroundImage.swift
//  SAReminder
//
//  Created by Alexei Sitalov on 3/25/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

//let backgroundImage = UIImage()


class GetBackgroundImage: NSObject, NSFetchedResultsControllerDelegate {
    
    var vc = ViewController ()
    
    static func getImage() -> UIImage {
        var imageName = NSString ()
        

        if DeviceType.IS_IPHONE_4_OR_LESS {
            imageName = "iphone_4_image.jpg"
        } else if DeviceType.IS_IPHONE_5 {
            imageName = "iphone_5_image.jpg"
        } else if DeviceType.IS_IPHONE_6 {
            imageName = "iphone_6_image.jpg"
        } else if DeviceType.IS_IPHONE_6P {
            imageName = "iphone_6+_image.jpg"
        }
        
        return UIImage(named: imageName as String)!
        
        
    }

}
