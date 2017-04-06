//
//  ServerResult+CoreDataProperties.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/5/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData


extension ServerResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServerResult> {
        return NSFetchRequest<ServerResult>(entityName: "ServerResult")
    }

    @NSManaged public var isContradictionString: String?
    @NSManaged public var isEntailmentString: String?
    @NSManaged public var isNeutralString: String?
    @NSManaged public var mostLikely: String?
    @NSManaged public var source: String?
    @NSManaged public var value: String?
    @NSManaged public var resultDictionary: ServerResultDictionary?

}
