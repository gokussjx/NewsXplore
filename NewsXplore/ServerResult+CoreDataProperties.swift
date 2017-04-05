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

    @NSManaged public var source: String?
    @NSManaged public var value: String?
    @NSManaged public var isNeutral: Bool
    @NSManaged public var isEntailment: Bool
    @NSManaged public var isContradiction: Bool
    @NSManaged public var mostLikely: String?
    @NSManaged public var resultDictionary: ServerResultDictionary?

}
