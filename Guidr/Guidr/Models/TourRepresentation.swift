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
    var miles: Int16?
    var date: Date?
    var imageURL: String?
    var identifier: String?
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
