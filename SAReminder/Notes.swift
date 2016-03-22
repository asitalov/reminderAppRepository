//
//  Notes.swift
//  
//
//  Created by Alexei Sitalov on 3/21/16.
//
//

import Foundation
import CoreData


class Notes: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    @NSManaged var titleText: String?
    @NSManaged var contentText: String?
    @NSManaged var buttonName: String?
    @NSManaged var date: String?
}
