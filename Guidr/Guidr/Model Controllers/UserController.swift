//
//  UserController.swift
//  Guidr
//
//  Created by Sean Acres on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case otherError
    case badData
    case noDecode
    case noEncode
    case badResponse
}

struct Bearer: Codable {
    let token: String
}

enum LoginType: String {
    case signUp = "register"
    case signIn = "login"
}

class UserController {
    var bearer: Bearer?
    var user: UserRepresentation?
    
    let baseURL = URL(string: "https://guidr-backend-justin-chen.herokuapp.com/user")!
    
    func loginWith(user: UserRepresentation, loginType: LoginType, completion: @escaping (NetworkError?) -> ()) {
        let requestURL = baseURL.appendingPathComponent("\(loginType.rawValue)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("error encoding: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print(response.statusCode)
                completion(.badResponse)
                return
            }
            
            if error != nil {
                completion(.otherError)
                return
            }
            
            if loginType == .signIn {
                guard let data = data else {
                    completion(.badData)
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                do {
                    self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
                    self.user = try jsonDecoder.decode(UserRepresentation.self, from: data)
                    
                    User(userRepresentation: self.user!)
                    try CoreDataStack.shared.save()
                    
                    if let bearer = self.bearer {
                        KeychainWrapper.standard.set(bearer.token, forKey: "token")
                        completion(nil)
                    }
                } catch {
                    print("error decoding data/token: \(error)")
                    completion(.noDecode)
                    return
                }
            }
        }.resume()
    }
    
    func signUpWith(user: UserRepresentation, loginType: LoginType, completion: @escaping (NetworkError?) -> ()) {
        let requestURL = baseURL.appendingPathComponent("\(loginType.rawValue)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("error encoding: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                print(response.statusCode)
                completion(.badResponse)
                return
            }
            
            if error != nil {
                completion(.otherError)
                return
            }
            
            guard let data = data else {
                completion(.badData)
                return
            }
            
            do {
                self.user = try JSONDecoder().decode(UserRepresentation.self, from: data)
                User(userRepresentation: self.user!)
                print("\(self.user)")
                try CoreDataStack.shared.save()
            } catch {
                completion(.noDecode)
            }
            
            completion(nil)
        }.resume()
    }
    
//    func getCurrentUser(for token: String, completion: @escaping (Result<UserRepresentation, NetworkError>) -> ()) {
//        let currentUserURL = baseURL.appendingPathComponent("current")
//        var request = URLRequest(url: currentUserURL)
//        request.httpMethod = HTTPMethod.get.rawValue
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let _ = error {
//                completion(.failure(.otherError))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.badData))
//                return
//            }
//
//            let jsonDecoder = JSONDecoder()
//            do {
//                self.user = try jsonDecoder.decode(UserRepresentation.self, from: data)
//                User(userRepresentation: self.user!)
//                try CoreDataStack.shared.save()
//                completion(.success(self.user!))
//            } catch {
//                completion(.failure(.noDecode))
//            }
//        }.resume()
//    }
}
