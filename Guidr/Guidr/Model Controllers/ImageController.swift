//
//  ImageController.swift
//  Guidr
//
//  Created by Sean Acres on 8/4/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Firebase

class ImageController {
    
    static let shared = ImageController()
    let imagesRef = Storage.storage().reference().child("images")
    
    func uploadImage(from data: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let imageID = UUID()
        let uploadRef = imagesRef.child("\(imageID).jpg")
        
        uploadRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                NSLog("Error uploading image: \(error)")
                completion(.failure(error))
                return
            }
            
            uploadRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    NSLog("Error getting download URL for image: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard url != nil else { return }
                
                completion(.success(imageID.uuidString))
            })
        }
    }
}
