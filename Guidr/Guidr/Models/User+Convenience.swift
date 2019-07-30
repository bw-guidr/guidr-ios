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
    @discardableResult convenience init(email: String?, password: String?, name: String?, imageURL: String?, identifier: Int32?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        // Set up NSManagedObject part of the class
        self.init(context: context)
        
        // Set up the unique parts of the User class
        
        self.email = email
        self.password = password
        self.name = name
        self.identifier = identifier!
        self.imageURL = imageURL
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.email = userRepresentation.email
        self.password = userRepresentation.password
        self.name = userRepresentation.name
        self.identifier = userRepresentation.identifier!
        self.imageURL = userRepresentation.imageURL
        
    }
    
    var userRepresentation: UserRepresentation {
        return UserRepresentation(email: email, password: password, name: name, imageURL: imageURL, identifier: identifier)
    }
}
