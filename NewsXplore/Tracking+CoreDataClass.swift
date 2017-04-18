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
    convenience init?(json: [String: Any]?, text: String?, postDate: Date?, analysisState: String?) {
        guard let context = CoreDataStack.sharedInstance.managedContext else {
            return nil
        }
        
        self.init(entity: Tracking.entity(), insertInto: context)
        
        parseAndStore(json: json, text: text, postDate: postDate, analysisState: analysisState)
    }
    
    func parseAndStore(json: [String: Any]?, text: String? = nil, postDate: Date? = nil, analysisState: String? = nil) {
        self.status = json?["status"] as? String
        self.trackingId = json?["data"] as? String
        if let text = text {
            self.text = text
        }
        if let date = postDate as NSDate? {
            self.postDate = date
        }
        if let analysisState = analysisState {
            self.analysisState = analysisState
        }
    }
}
