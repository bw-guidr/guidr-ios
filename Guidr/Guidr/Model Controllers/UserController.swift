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

enum LoginType: String {
    case signUp = "register"
    case signIn = "login"
}

class UserController {
    var token: String?
    var user: UserRepresentation?
    
    static let shared = UserController()
    
    let baseURL = URL(string: "https://guidr-backend-justin-chen.herokuapp.com/user")!
    
    func loginWith(user: UserRepresentation, loginType: LoginType, completion: @escaping (Result<String, NetworkError>) -> ()) {
        let requestURL = baseURL.appendingPathComponent("\(loginType.rawValue)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("error encoding: \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print(response.statusCode)
                completion(.failure(.badResponse))
                return
            }
            
            if error != nil {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let result = try jsonDecoder.decode(UserResult.self, from: data)
                self.token = result.token
                self.user = result.user
                let context = CoreDataStack.shared.mainContext
                
                context.performAndWait {
                    User(userRepresentation: self.user!)
                }
                
                try CoreDataStack.shared.save()
                if let token = self.token {
                    KeychainWrapper.standard.set(token, forKey: "token")
                    completion(.success(token))
                }
            } catch {
                print("error decoding data/token: \(error)")
                completion(.failure(.noDecode))
                return
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
                try CoreDataStack.shared.save()
            } catch {
                completion(.noDecode)
            }
            
            completion(nil)
        }.resume()
    }
}
