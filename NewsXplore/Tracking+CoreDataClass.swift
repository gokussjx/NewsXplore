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
    
    var entityExtractedArray: [EntityExtracted]? {
        return self.entityExtracted?.allObjects as? [EntityExtracted]
    }
    
    @discardableResult
    convenience init?(json: [String: Any]?, text: String?, postDate: Date?, inputEntityTrackingId: String?, extractedEntities: [EntityExtracted?]?) {
        guard let context = CoreDataStack.sharedInstance.managedContext else {
            return nil
        }
        
        self.init(entity: Tracking.entity(), insertInto: context)
        
        parseAndStore(json: json, text: text, postDate: postDate, inputEntityTrackingId: inputEntityTrackingId, extractedEntities: extractedEntities)
    }
    
    func parseAndStore(json: [String: Any]?, text: String? = nil, postDate: Date? = nil, inputEntityTrackingId: String? = nil, extractedEntities: [EntityExtracted?]? = []) {
        self.status = json?["status"] as? String
        self.trackingId = json?["data"] as? String
        if let text = text {
            self.text = text
        }
        if let date = postDate as NSDate? {
            self.postDate = date
        }
        if let status = self.status {
            switch status {
            case "pending":
                self.analysisState = "In Progress"
                break
            case "ok":
                self.analysisState = "Ready"
                break
            default:
                self.analysisState = "Error"
            }
        }
        if let inputEntityTrackingId = inputEntityTrackingId {
            self.inputEntityTrackingId = inputEntityTrackingId
        }
        guard let extractedEntities = extractedEntities else {
            return
        }
        for entityExtracted in extractedEntities {
            if let entity = entityExtracted {
                addToEntityExtracted(entity)
            }
        }
        
    }
}
