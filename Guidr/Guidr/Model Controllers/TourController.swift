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
    
    static let shared = TourController()
    
    let userURL = URL(string: "https://guidr-backend-justin-chen.herokuapp.com/user")!
    let tripURL: URL = URL(string: "https://guidr-backend-justin-chen.herokuapp.com/trips")!
    
    func createTour(title: String, description: String?, miles: Float, date: String, userID: Int, imageURL: String?, location: String?, tourType: String?) {
        
        let tourRepresentation = TourRepresentation(title: title, description: description, miles: miles, date: date, imageURL: nil, userID: Int32(userID), identifier: nil, tourType: tourType ?? "", location: location ?? "")
        
        post(tour: tourRepresentation)
    }
    
    func updateTour(tour: Tour, title: String, description: String?, miles: Float, imageURL: String?, date: String, tourType: String) {
        let tourRepresentation = TourRepresentation(title: title, description: description, miles: miles, date: date, imageURL: nil, userID: tour.userID, identifier: tour.identifier, tourType: tourType, location: title)
        put(tour: tourRepresentation)
        
        tour.title = title
        tour.location = title
        tour.summary = description
        tour.miles = miles
        tour.date = date
        tour.imageURL = imageURL
        tour.tourType = tourType
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func deleteTour(tour: Tour) {
        let moc = CoreDataStack.shared.mainContext
        
        
        deleteTourFromServer(tour: tour)
        moc.delete(tour)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }
    
    func fetchToursFromServer(userID: Int, completion: @escaping () -> Void = { }) {
        let requestURL = userURL.appendingPathComponent("\(userID)").appendingPathComponent("trips")
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
                let tourRepresentations = try JSONDecoder().decode([TourRepresentation].self, from: data)
                
                self.updateTours(with: tourRepresentations)
                try CoreDataStack.shared.save()
            } catch {
                NSLog("Error decoding entry representations \(error)")
                completion()
                return
            }
            }.resume()
    }
    
    func post(tour: TourRepresentation, completion: @escaping () -> Void = { }) {
        let requestURL: URL = userURL.appendingPathComponent("\(tour.userID)").appendingPathComponent("trips")
        print(requestURL)
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        
        if let token = token {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(tour)
        } catch {
            NSLog("Error encoding tour \(tour): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error PUTting tour to server: \(error)")
                completion()
                return
            }
            
            guard let data = data else { return }
            do {
                let tourID = try JSONDecoder().decode([Int].self, from: data)
                let moc = CoreDataStack.shared.mainContext
                moc.performAndWait {
                    let tour = Tour(tourRepresentation: tour)
                    guard let identifier = tourID.first else { return }
                    tour?.identifier = Int32(identifier)
                }
                
                try CoreDataStack.shared.save()
            } catch {
                NSLog("Error decoding tourID and saving tour: \(error)")
            }
            
            completion()
        }.resume()
    }
    
    func put(tour: TourRepresentation, completion: @escaping () -> Void = { }) {
        guard let identifier = tour.identifier else { return }
        
        let requestURL: URL = tripURL.appendingPathComponent("\(identifier)")

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        
        if let token = token {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(tour)
            request.httpBody?.printJSON()
        } catch {
            NSLog("Error encoding tour \(tour): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error PUTting tour to server: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
    
    func deleteTourFromServer(tour: Tour, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = tripURL.appendingPathComponent("\(tour.identifier)")

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        
        if let token = token {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting tour from server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    private func fetchSingleTourFromPersistentStore(identifier: Int32, context: NSManagedObjectContext) -> Tour? {
        let fetchRequest: NSFetchRequest<Tour> = Tour.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %i", identifier)
        
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
    
    private func updateTours(with representations: [TourRepresentation], context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            for representation in representations {
                guard let identifier = representation.identifier else { return }
                print(identifier)
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

extension Data {
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
    }
}
