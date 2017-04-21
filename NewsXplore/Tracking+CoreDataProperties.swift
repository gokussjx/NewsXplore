//
//  Tracking+CoreDataProperties.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/21/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData


extension Tracking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tracking> {
        return NSFetchRequest<Tracking>(entityName: "Tracking")
    }

    @NSManaged public var analysisState: String?
    @NSManaged public var inputEntityTrackingId: String?
    @NSManaged public var postDate: NSDate?
    @NSManaged public var status: String?
    @NSManaged public var text: String?
    @NSManaged public var trackingId: String?
    @NSManaged public var overview: String?
    @NSManaged public var statusPoll: StatusPoll?
    @NSManaged public var entityExtracted: NSSet?

}

// MARK: Generated accessors for entityExtracted
extension Tracking {

    @objc(addEntityExtractedObject:)
    @NSManaged public func addToEntityExtracted(_ value: EntityExtracted)

    @objc(removeEntityExtractedObject:)
    @NSManaged public func removeFromEntityExtracted(_ value: EntityExtracted)

    @objc(addEntityExtracted:)
    @NSManaged public func addToEntityExtracted(_ values: NSSet)

    @objc(removeEntityExtracted:)
    @NSManaged public func removeFromEntityExtracted(_ values: NSSet)

}
