//
//  EntityExtracted+CoreDataClass.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/19/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData

@objc(EntityExtracted)
public class EntityExtracted: NSManagedObject {
    
    @discardableResult
    convenience init?(json: [String: Any]?) {
        guard let context = CoreDataStack.sharedInstance.managedContext else {
            return nil
        }
        
        self.init(entity: EntityExtracted.entity(), insertInto: context)
        
        parseAndStore(json: json)
    }
    
    func parseAndStore(json: [String: Any]?) {
    
        self.sentiment = json?["sentiment"] as? String
        if let salience = json?["salience"] as? Double {
            self.salience = salience
        }
        self.name = json?["name"] as? String
        self.entityType = json?["entity_type"] as? String
        if let metadata = json?["metadata"] as? [String: Any] {
            self.url = metadata["wikipedia_url"] as? String
        }
    }
    
}
