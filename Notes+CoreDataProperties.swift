//
//  Notes+CoreDataProperties.swift
//  
//
//  Created by Alexei Sitalov on 3/21/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Notes {

    @NSManaged var titleText: String?
    @NSManaged var contentText: String?
    @NSManaged var buttonName: String?
    @NSManaged var date: String?

}
