//
//  ServerResultDictionary+CoreDataProperties.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/18/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData


extension ServerResultDictionary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServerResultDictionary> {
        return NSFetchRequest<ServerResultDictionary>(entityName: "ServerResultDictionary")
    }

    @NSManaged public var dataSource: String?
    @NSManaged public var title: String?
    @NSManaged public var srcUrl: String?
    @NSManaged public var results: NSSet?
    @NSManaged public var statusPoll: StatusPoll?

}

// MARK: Generated accessors for results
extension ServerResultDictionary {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: ServerResult)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: ServerResult)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}
