//
//  Tour+Convenience.swift
//  Guidr
//
//  Created by Sean Acres on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

extension Tour {
    @discardableResult convenience init(title: String?, description: String?, miles: Float, date: String, userID: Int32, imageURL: String, location: String, tourType: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        // Set up NSManagedObject part of the class
        self.init(context: context)
        // Set up the unique parts of the Tour class
        self.title = title
        self.summary = description
        self.date = date
        self.userID = userID
        self.miles = miles
        self.imageURL = imageURL
        self.location = location
        self.tourType = tourType
    }
    
    @discardableResult convenience init?(tourRepresentation: TourRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        if let miles = tourRepresentation.miles {
            self.miles = miles
        }
        
        self.title = tourRepresentation.title
        self.summary = tourRepresentation.description
        self.date = tourRepresentation.date
        self.userID = tourRepresentation.userID
        self.imageURL = tourRepresentation.imageURL
        self.location = tourRepresentation.location
        self.tourType = tourRepresentation.tourType
        self.identifier = tourRepresentation.identifier
    }
    
    var tourRepresentation: TourRepresentation {
        return TourRepresentation(title: title, description: description, miles: miles, date: date, imageURL: imageURL, userID: userID, identifier: identifier, tourType: tourType, location: location)
    }
}
