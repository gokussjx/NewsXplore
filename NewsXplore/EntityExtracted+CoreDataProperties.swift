//
//  EntityExtracted+CoreDataProperties.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/19/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData


extension EntityExtracted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityExtracted> {
        return NSFetchRequest<EntityExtracted>(entityName: "EntityExtracted")
    }

    @NSManaged public var sentiment: String?
    @NSManaged public var salience: Double
    @NSManaged public var name: String?
    @NSManaged public var entityType: String?
    @NSManaged public var url: String?
    @NSManaged public var tracking: Tracking?

}
