//
//  Notes.swift
//  
//
//  Created by Alexei Sitalov on 3/23/16.
//
//

import Foundation
import CoreData


class Notes: NSManagedObject {

    @NSManaged var buttonName: String?
    @NSManaged var contentText: String?
    @NSManaged var date: String?
    @NSManaged var status: String?
    @NSManaged var titleText: String?
    @NSManaged var index: NSNumber?
    @NSManaged var dateInDateFormat: NSDate?
    @NSManaged var someTimeBefore: NSDate?

}
