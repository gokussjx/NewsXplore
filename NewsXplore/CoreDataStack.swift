//
//  CoreDataStack.swift
//  NewsXplore
//
//  Created by Bidyut Mukherjee on 4/5/17.
//  Copyright © 2017 NewsXplore. All rights reserved.
//

//  (Sourced from:)
//  Model.swift
//  CoreDataRelationships
//
//  Created by Shawn Moore on 3/5/17.
//  Copyright © 2017 Tech Innovator. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    // MARK: - Properties
    var managedContext: NSManagedObjectContext?
    
    // MARK: Static
    static var sharedInstance: CoreDataStack = CoreDataStack()
    
    // MARK: - Initializer
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let persistentContainer = appDelegate?.persistentContainer
        managedContext = persistentContainer?.viewContext
    }
    
    // MARK: - Core Data Functions
//    func loadData() {
//        let coreDataLoadedKey = "hasLoadedCoreData"
//        
//        guard !UserDefaults.standard.bool(forKey: coreDataLoadedKey) else { return }
//        
//        let newsCategories = NewsJSONLoader.load(fileName: "news")
//        
//        for newsCategory in newsCategories {
//            if let category = Category(title: newsCategory.title) {
//                for newsArticle in newsCategory.articles {
//                    if let article = Article(title: newsArticle.title, date: newsArticle.date) {
//                        category.addToArticles(article)
//                    }
//                }
//            }
//        }
//        
//        do {
//            try self.managedContext?.save()
//            
//            UserDefaults.standard.set(true, forKey: coreDataLoadedKey)
//        } catch {
//            return
//        }
//    }
//    
//    
//    func fetchCategories() -> [Category] {
//        do {
//            let array = try managedContext?.fetch(Category.fetchRequest()) ?? []
//            return array
//        } catch {
//            return []
//        }
//    }
    
    @discardableResult
    func updateOrInsertTracking(json: [String: Any]?) -> Tracking? {
        
        guard let trackingId = json?["data"] as? String else {
            return nil
        }
        
        var tracking: Tracking?
        
        let fetchRequest: NSFetchRequest<Tracking> = Tracking.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackingId == %@", trackingId)

        // let trackingEntities = try fetchRequest.execute()
        guard let trackingEntities = try? managedContext?.fetch(fetchRequest) ?? [] else {
            return nil
        }
        
        if trackingEntities.count == 0 {
            tracking = Tracking(json: json)
        } else if trackingEntities.count == 1 {
            tracking = trackingEntities[0]
            tracking?.parseAndStore(json: json)
        } else {
            debugPrint("More than one Tracking entities with same trackingID!")
        }
        
        saveContext()
        
        return tracking
    }
    
    @discardableResult
    func updateOrInsertStatusPoll(json: [String: Any]?, tracking: Tracking?) -> StatusPoll? {
        
        guard let trackingId = tracking?.trackingId else {
            return nil
        }
        
        var statusPoll: StatusPoll?
        
        let fetchRequest: NSFetchRequest<StatusPoll> = StatusPoll.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY tracking.trackingId == %@", trackingId)
        
        guard let statusPollEntities = try? managedContext?.fetch(fetchRequest) ?? [] else {
            return nil
        }
        
        if statusPollEntities.count == 0 {
            statusPoll = StatusPoll(json: json)
            tracking?.statusPoll = statusPoll
        } else if statusPollEntities.count == 1 {
            statusPoll = statusPollEntities[0]
            statusPoll?.parseAndStore(json: json)
            tracking?.statusPoll = statusPoll   // Might be unnecessary
        } else {
            debugPrint("More than one StatusPoll entities with same trackingID!")
        }
        
        saveContext()
        
        return statusPoll
    }
    
    func saveContext() {
        guard let context = managedContext,
            context.hasChanges else { return }
        
        try? context.save()
    }
}
