//
//  TourController.swift
//  Guidr
//
//  Created by Sean Acres on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum PutType: String {
    case add
    case update
}

class TourController {
    
    init() {
        fetchToursFromServer()
    }
    
    let baseURL = URL(string: "user")!
    
    func createTour(title: String, description: String?, miles: Int32, date: Date, userID: Int32) {
        let tour = Tour(title: title, description: description, miles: miles, date: date, userID: userID)
        
        put(tour: tour, type: .add)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func updateTour(tour: Tour, title: String, description: String?, miles: Int32, imageURL: String?, date: Date) {
        tour.title = title
        tour.summary = description
        tour.miles = miles
        tour.date = date
        tour.imageURL = imageURL
        
        put(tour: tour, type: .update)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func deleteTour(tour: Tour) {
        let moc = CoreDataStack.shared.mainContext
        
        moc.delete(tour)
        deleteTourFromServer(tour: tour)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func fetchToursFromServer(completion: @escaping () -> Void = { }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Bad response fetching tours, response code: \(response.statusCode)")
                completion()
                return
            }
            
            if let error = error {
                NSLog("Error fetching tours from server: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetching tours from server")
                completion()
                return
            }
            
            do {
                let decodedJSON = try JSONDecoder().decode([String : TourRepresentation].self, from: data)
                let tourRepresentations = Array(decodedJSON.values)
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                
                self.updateTours(with: tourRepresentations, context: backgroundContext)
                try CoreDataStack.shared.save(context: backgroundContext)
            } catch {
                NSLog("Error decoding entry representations \(error)")
                completion()
                return
            }
            }.resume()
    }
    
    func put(tour: Tour, type: PutType,completion: @escaping () -> Void = { }) {
        let requestURL: URL
        if type == .add {
            requestURL = baseURL.appendingPathComponent("\(tour.userID)").appendingPathComponent("trips")
        } else if type == .update {
            requestURL = baseURL.appendingPathComponent("trips").appendingPathComponent("\(tour.identifier)")
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(tour.tourRepresentation)
        } catch {
            NSLog("Error encoding tour \(tour): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting tour to server: \(error)")
                completion()
                return
            }
            
            completion()
            }.resume()
    }
    
    func deleteTourFromServer(tour: Tour, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("trips").appendingPathComponent("\(tour.identifier)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting tour from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    private func fetchSingleTourFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Tour? {
        let fetchRequest: NSFetchRequest<Tour> = Tour.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@")
        
        var tour: Tour? = nil
        
        context.performAndWait {
            do {
                tour = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching tour with identifier \(identifier): \(error)")
            }
        }
        
        return tour
    }
    
    private func update(tour: Tour, representation: TourRepresentation) {
        tour.title = representation.title
        tour.summary = representation.description
        tour.miles = representation.miles!
        tour.date = representation.date
        tour.imageURL = representation.imageURL
    }
    
    private func updateTours(with representations: [TourRepresentation], context: NSManagedObjectContext) {
        context.performAndWait {
            for representation in representations {
                let identifier = "\(representation.userID)"
                let tour = fetchSingleTourFromPersistentStore(identifier: identifier, context: context)
                
                if let tour = tour {
                    if tour != representation {
                        update(tour: tour, representation: representation)
                    }
                } else {
                    Tour(tourRepresentation: representation)
                }
            }
        }
    }
}
