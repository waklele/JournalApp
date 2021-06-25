//
//  Journal+CoreDataProperties.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/25/21.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var id: Int64
    @NSManaged public var lastUpdateDate: Date?
    @NSManaged public var puzzle1Detail: String?
    @NSManaged public var puzzle2Detail: String?
    @NSManaged public var puzzle3Detail: String?
    @NSManaged public var puzzle4Detail: String?
    @NSManaged public var title: String?

}

extension Journal : Identifiable {

}
