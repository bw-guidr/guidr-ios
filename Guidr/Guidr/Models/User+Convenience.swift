//
//  User+Convenience.swift
//  Guidr
//
//  Created by Sean Acres on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

extension User {
    @discardableResult convenience init(name: String?, imageURL: String?, identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        // Set up NSManagedObject part of the class
        self.init(context: context)
        
        // Set up the unique parts of the Task class
        self.name = name
        self.identifier = identifier
        self.imageURL = imageURL
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.name = userRepresentation.name
        self.identifier = userRepresentation.identifier
        self.imageURL = userRepresentation.imageURL
        
    }
    
    var tourRepresentation: UserRepresentation {
        return UserRepresentation(name: name, imageURL: imageURL, identifier: identifier)
    }
}
