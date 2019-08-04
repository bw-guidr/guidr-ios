//
//  TourGalleryCollectionViewController.swift
//  Guidr
//
//  Created by Jake Connerly on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit
import CoreData
import FirebaseUI

class TourGalleryCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    let tourController = TourController.shared
    
    var user: UserRepresentation {
        let moc = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try moc.fetch(request)
            if let user = users.first {
                return user.userRepresentation
            }
        } catch {
            fatalError("Error performing fetch for user: \(error)")
        }
        return UserRepresentation()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Tour> = {
        let fetchRequest: NSFetchRequest<Tour> = Tour.fetchRequest()
        
        // FRCs need at least one sort descriptor. If you are using "sectionNameKeyPath", the first sort descriptor must be the same attribute
        let dateDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let titleDescriptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor, titleDescriptor]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            guard let tourDetailVC = segue.destination.children.first as? TourDetailViewController, let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            
            tourDetailVC.tour = fetchedResultsController.fetchedObjects?[indexPath.item]
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TourCell", for: indexPath) as? TourCollectionViewCell else { return UICollectionViewCell() }
    
        let tour = fetchedResultsController.object(at: indexPath)
        cell.tour = tour
        if let imageURL = tour.imageURL {
            let imageRef = Storage.storage().reference().child("images/\(imageURL)")
            cell.tourImageView.sd_setImage(with: imageRef)
        }
    
        return cell
    }


    // MARK: NSFetchedResultsControllerDelegate
    private var sectionChanges = [(type: NSFetchedResultsChangeType, sectionIndex: Int)]()
    private var itemChanges = [(type: NSFetchedResultsChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?)]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        sectionChanges.append((type, sectionIndex))
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        itemChanges.append((type, indexPath, newIndexPath))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        collectionView?.performBatchUpdates({
            
            for change in self.sectionChanges {
                switch change.type {
                case .insert: self.collectionView?.insertSections([change.sectionIndex])
                case .delete: self.collectionView?.deleteSections([change.sectionIndex])
                default: break
                }
            }
            
            for change in self.itemChanges {
                switch change.type {
                case .insert: self.collectionView?.insertItems(at: [change.newIndexPath!])
                case .delete: self.collectionView?.deleteItems(at: [change.indexPath!])
                case .update: self.collectionView?.reloadItems(at: [change.indexPath!])
                case .move:
                    self.collectionView?.deleteItems(at: [change.indexPath!])
                    self.collectionView?.insertItems(at: [change.newIndexPath!])
                @unknown default:
                    fatalError()
                }
            }
            
            self.sectionChanges.removeAll()
            self.itemChanges.removeAll()
            
        }, completion: { finished in
            // moved section and item changes from here
        })
    }
}
