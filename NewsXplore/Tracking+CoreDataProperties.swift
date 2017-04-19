//
//  Tracking+CoreDataProperties.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/18/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData


extension Tracking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tracking> {
        return NSFetchRequest<Tracking>(entityName: "Tracking")
    }

    @NSManaged public var status: String?
    @NSManaged public var trackingId: String?
    @NSManaged public var postDate: NSDate?
    @NSManaged public var analysisState: String?
    @NSManaged public var text: String?
    @NSManaged public var inputEntityTrackingId: String?
    @NSManaged public var statusPoll: StatusPoll?

}
