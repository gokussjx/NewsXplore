//
//  StatusPoll+CoreDataProperties.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/5/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData


extension StatusPoll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatusPoll> {
        return NSFetchRequest<StatusPoll>(entityName: "StatusPoll")
    }

    @NSManaged public var status: String?
    @NSManaged public var errorMessage: String?
    @NSManaged public var resultsDictionary: NSSet?

}

// MARK: Generated accessors for resultsDictionary
extension StatusPoll {

    @objc(addResultsDictionaryObject:)
    @NSManaged public func addToResultsDictionary(_ value: ServerResultDictionary)

    @objc(removeResultsDictionaryObject:)
    @NSManaged public func removeFromResultsDictionary(_ value: ServerResultDictionary)

    @objc(addResultsDictionary:)
    @NSManaged public func addToResultsDictionary(_ values: NSSet)

    @objc(removeResultsDictionary:)
    @NSManaged public func removeFromResultsDictionary(_ values: NSSet)

}
