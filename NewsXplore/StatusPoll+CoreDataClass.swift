//
//  StatusPoll+CoreDataClass.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/5/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData

@objc(StatusPoll)
public class StatusPoll: NSManagedObject {
    
    var resultsDictionaryArray: [ServerResultDictionary]? {
        return self.resultsDictionary?.allObjects as? [ServerResultDictionary]
    }
    
    convenience init?(json: [String: Any]?) {
        guard let context = CoreDataStack.sharedInstance.managedContext else {
            return nil
        }
        
        self.init(entity: StatusPoll.entity(), insertInto: context)
        
        parseAndStore(json: json)
    }
    
    func parseAndStore(json: [String: Any]?) {
        self.status = json?["status"] as? String
        self.errorMessage = json?["msg"] as? String
        
        if let resultDicts = json?["data"] as? [[String: Any]?] {
            for resultDict in resultDicts {
                if let resultDict = ServerResultDictionary(json: resultDict) {
                    addToResultsDictionary(resultDict)
                }
            }
        }
        
        CoreDataStack.sharedInstance.saveContext()
    }
}
