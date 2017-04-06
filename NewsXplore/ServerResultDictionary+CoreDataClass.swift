//
//  ServerResultDictionary+CoreDataClass.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/5/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData

@objc(ServerResultDictionary)
public class ServerResultDictionary: NSManagedObject {
    
    // TODO: Check that the inverse relationship to StatusPoll is added
    
    var resultsArray: [ServerResult]? {
        return self.results?.allObjects as? [ServerResult]
    }
    
    convenience init?(json: [String: Any]?) {
        guard let context = CoreDataStack.sharedInstance.managedContext else {
            return nil
        }
        
        self.init(entity: ServerResultDictionary.entity(), insertInto: context)
        
        parseAndStore(json: json)
    }
    
    func parseAndStore(json: [String: Any]?) {
        self.dataSource = json?["dataSrc"] as? String
        self.title = json?["title"] as? String
        if let results = json?["statements"] as? [[String: Any]?] {
            for result in results {
                if let result = ServerResult(json: result) {
                    // TODO: Check that the inverse relationship to this ServerResultDictionary is added
                    addToResults(result)
                }
            }
        }
        //        if let results = json?["data"] as? [String: Any]? {
        //            for result in (results?.values)! {
        //                if let result = ServerResult(json: result as? [String: Any]) {
        //                    // TODO: Check that the inverse relationship to this ServerResultDictionary is added
        //                    addToResults(result)
        //                }
        //            }
        //        }
        
    }
    
    //    @NSManaged public var results: NSSet?
    //    @NSManaged public var statusPoll: StatusPoll?
}
