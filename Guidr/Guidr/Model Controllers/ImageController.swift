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
    
    func fetchImage(at urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let imageURL = URL(string: urlString) else  {
            completion(.failure(.otherError))
            return
        }
        
        var request = URLRequest(url: imageURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.badData))
                return
            }
            
            completion(.success(image))
        }.resume()
    }
    
    func uploadImage(from data: Data, completion: @escaping (Result<URL, Error>) -> Void) {
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
                
                guard let downloadURL = url else { return }
                
                completion(.success(downloadURL))
            })
        }
    }
}
