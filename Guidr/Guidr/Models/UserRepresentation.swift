//
//  UserRepresentation.swift
//  Guidr
//
//  Created by Sean Acres on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

struct UserResult: Codable {
    var user: UserRepresentation
    var token: String
}

struct UserRepresentation: Codable {
    var email: String?
    var password: String?
    var name: String?
    var imageURL: String?
    var identifier: Int?
    
    enum CodingKeys: String, CodingKey {
        case email = "username"
        case password
        case name
        case imageURL = "image_url"
        case identifier = "id"
    }
}

extension UserRepresentation: Equatable {
    static func == (lhs: UserRepresentation, rhs: User) -> Bool {
        return lhs.identifier == Int(rhs.identifier)
    }
    
    static func == (lhs: User, rhs: UserRepresentation) -> Bool {
        return rhs == lhs
    }
    
    static func != (lhs: User, rhs: UserRepresentation) -> Bool {
        return rhs != lhs
    }
    
    static func != (lhs: UserRepresentation, rhs: User) -> Bool {
        return !(rhs == lhs)
    }
}
