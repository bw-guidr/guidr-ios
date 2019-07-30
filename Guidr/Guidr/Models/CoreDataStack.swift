//
//  CoreDataStack.swift
//  Guidr
//
//  Created by Sean Acres on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError{
                error = saveError
            }
        }
        
        if let error = error {
            throw error
        }
    }
    
    lazy var container: NSPersistentContainer = {
        
        // Give the container the name of your data model file
        let container = NSPersistentContainer(name: "Guidr")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        
        // This will merge any tasks that are created on a background context to the view context
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // Remember to use the viewContext on the main thread only
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
