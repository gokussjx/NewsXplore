//
//  ServerResult+CoreDataClass.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/5/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

import Foundation
import CoreData

@objc(ServerResult)
public class ServerResult: NSManagedObject {
    
    var isNeutral: Bool? {
        get {
            guard let isNeutralString = self.isNeutralString else {
                return nil
            }
            return isNeutralString.contains("True") ? true : false
        }
        
        set {
            guard let newValue = newValue else {
                self.isNeutralString = nil
                return
            }
            self.isNeutralString = newValue ? "True" : "False"
        }
    }
    
    var isEntailment: Bool? {
        get {
            guard let isEntailmentString = self.isEntailmentString else {
                return nil
            }
            return isEntailmentString.contains("True") ? true : false
        }
        
        set {
            guard let newValue = newValue else {
                self.isEntailmentString = nil
                return
            }
            self.isEntailmentString = newValue ? "True" : "False"
        }
    }
    
    var isContradiction: Bool? {
        get {
            guard let isContradictionString = self.isContradictionString else {
                return nil
            }
            return isContradictionString.contains("True") ? true : false
        }
        
        set {
            guard let newValue = newValue else {
                self.isContradictionString = nil
                return
            }
            self.isContradictionString = newValue ? "True" : "False"
        }
    }
    
    convenience init?(json: [String: Any]?) {
        guard let context = CoreDataStack.sharedInstance.managedContext else {
            return nil
        }
        
        self.init(entity: ServerResult.entity(), insertInto: context)
        
        parseAndStore(json: json)
    }
    
    func parseAndStore(json: [String: Any]?) {
        self.source = json?["src"] as? String
        self.value = json?["value"] as? String
        self.isNeutralString = json?["is_neutral"] as? String
        self.isEntailmentString = json?["is_entailment"] as? String
        self.isContradictionString = json?["is_contradiction"] as? String
        self.mostLikely = json?["most_likely"] as? String
        
        CoreDataStack.sharedInstance.saveContext()
    }
}
