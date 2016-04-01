//
//  Notes+CoreDataProperties.swift
//  
//
//  Created by Alexei Sitalov on 3/31/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Notes {

    @NSManaged var buttonName: String?
    @NSManaged var contentText: String?
    @NSManaged var date: String?
    @NSManaged var dateInDateFormat: NSDate?
    @NSManaged var index: NSNumber?
    @NSManaged var someTimeBefore: NSDate?
    @NSManaged var status: String?
    @NSManaged var titleText: String?
    @NSManaged var searchDate: NSDate?

}
