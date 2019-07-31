//
//  TourRepresentation.swift
//  Guidr
//
//  Created by Sean Acres on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

struct TourRepresentation: Codable {
    var title: String?
    var description: String?
    var miles: Float?
    var date: String?
    var imageURL: String?
    var userID: Int32
    var identifier: Int32
    var tourType: String?
    var location: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case miles
        case imageURL
        case userID = "user_id"
        case identifier = "id"
        case tourType = "trip_type"
        case location
    }
}

extension TourRepresentation: Equatable {
    static func == (lhs: TourRepresentation, rhs: Tour) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    static func == (lhs: Tour, rhs: TourRepresentation) -> Bool {
        return rhs == lhs
    }
    
    static func != (lhs: Tour, rhs: TourRepresentation) -> Bool {
        return rhs != lhs
    }
    
    static func != (lhs: TourRepresentation, rhs: Tour) -> Bool {
        return !(rhs == lhs)
    }
}
