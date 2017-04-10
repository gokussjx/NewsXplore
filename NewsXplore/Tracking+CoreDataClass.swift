//
//  Tracking+CoreDataClass.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/5/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData

@objc(Tracking)
public class Tracking: NSManagedObject {
    
    @discardableResult
    convenience init?(json: [String: Any]?) {
        guard let context = CoreDataStack.sharedInstance.managedContext else {
            return nil
        }
        
        self.init(entity: Tracking.entity(), insertInto: context)
        
        parseAndStore(json: json)
    }
    
    func parseAndStore(json: [String: Any]?) {
        self.status = json?["status"] as? String
        self.trackingId = json?["data"] as? String
    }
}
