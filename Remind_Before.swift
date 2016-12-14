//
//  Remind_Before.swift
//  SAReminder
//
//  Created by Alexei Sitalov on 3/28/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class Remind_Before {

    
    static func scheduleBefore(index:Int) -> NSDateComponents {
        
        let dateComponents = NSDateComponents ()

        if index == 1 {
            dateComponents.minute = -5
        } else if index == 2 {
            dateComponents.minute = -10
        }else if index == 3 {
            dateComponents.minute = -15
        }else if index == 4 {
            dateComponents.minute = -30
        } else if index == 5 {
            dateComponents.minute = -60
        }   else if index == 6 {
            dateComponents.minute = -1140
                
        }
        
        return dateComponents
    }

    
  static func truncateSecondsForDate(fromDate: NSDate) -> NSDate {
        
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let unitFlags : NSCalendarUnit = [.Era, .Year, .Month, .Day, .Hour, .Minute]
        let fromDateComponents: NSDateComponents = calendar.components(unitFlags, fromDate: fromDate)
        
        return calendar.dateFromComponents(fromDateComponents)!
        
    }
    
    static func truncateDaysForDate(fromDate: NSDate) -> NSDate {
        
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let unitFlags : NSCalendarUnit = [.Year, .Month, .Day]
        let fromDateComponents: NSDateComponents = calendar.components(unitFlags, fromDate: fromDate)
        
        return calendar.dateFromComponents(fromDateComponents)!
        
    }
}