//
//  ProfileViewController.swift
//  Guidr
//
//  Created by Marlon Raskin on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

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
    
	var tourPhotos: [UIImage] = [UIImage(named: "bearVector")!, UIImage(named: "hikeVector")!, UIImage(named: "MountainRedVector")!, UIImage(named: "treeAndMoonVector")!, UIImage(named: "MountainVector")!]

	let miles = "272"
	let tours = "15"
	let locations = "9"
    
    let token: String? = KeychainWrapper.standard.string(forKey: "token")

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.barTintColor = .black
		tabBarController?.tabBar.tintColor = .mainPeach
        print("\(token ?? "")")
        // check if first launch or not logged in
        if UserDefaults.isFirstLaunch() && token == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else if token == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else if user.identifier == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
        
        if let id = user.identifier {
            tourController.fetchToursFromServer(userID: id)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            guard let tourDetailVC = segue.destination.children.first as? TourDetailViewController, let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            
            tourDetailVC.tour = fetchedResultsController.fetchedObjects?[indexPath.item]
        }
    }
	

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		// Tour Guide Info
		case 0:
			return 1
		// Add First Tour Button
		case 1:
			return tourPhotos.count == 0 ? 1 : 0
		// Tour Photos Grid
		default:
            return fetchedResultsController.fetchedObjects?.count ?? 0
		}
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		switch indexPath.section {
		case 0:
			return guideInfoCell(from: collectionView.dequeueReusableCell(withReuseIdentifier: "GuideInfoCell", for: indexPath), atIndex: indexPath.item)
		default:
            return tourPhotoCell(from: collectionView.dequeueReusableCell(withReuseIdentifier: "TourPhotoCell", for: indexPath), indexPath: indexPath, atIndex: indexPath.item)
		}
    }

	private func guideInfoCell(from cell: UICollectionViewCell, atIndex index: Int) -> GuideInfoCollectionViewCell {
		guard let cell = cell as? GuideInfoCollectionViewCell else { return GuideInfoCollectionViewCell() }
        cell.tourCountLabel.text = "\(getLocationsCount())"
		cell.milesCountLabel.text = "\(getMilesCount())"
		cell.locationsCountLabel.text = "\(getLocationsCount())"
		cell.nameLabel.text = user.name
		cell.profileImageView.image = UIImage(named: "profilePhoto")

		return cell
	}

    private func tourPhotoCell(from cell: UICollectionViewCell, indexPath: IndexPath, atIndex index: Int) -> TourPhotoCollectionViewCell {
		guard let cell = cell as? TourPhotoCollectionViewCell else { return TourPhotoCollectionViewCell() }
		cell.tourImageView.image = tourPhotos.randomElement()
        
        let tour = fetchedResultsController.object(at: IndexPath(item: index, section: 0))
        cell.tour = tour
        
		return cell
	}
    
    private func getMilesCount() -> Float {
        var milesCount: Float = 0.0
        guard let tours = fetchedResultsController.fetchedObjects else { return 0.0 }
        for tour in tours {
            milesCount += tour.miles
        }
        
        return milesCount
    }
    
    private func getLocationsCount() -> Int {
        var locationsCount: Int = 0
        guard let tours = fetchedResultsController.fetchedObjects else { return 0 }
        for _ in tours {
            locationsCount += 1
        }
        
        return locationsCount
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    private var sectionChanges = [(type: NSFetchedResultsChangeType, sectionIndex: Int)]()
    private var itemChanges = [(type: NSFetchedResultsChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?)]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        sectionChanges.append((type, sectionIndex))
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let adjustedIndexPath = IndexPath(item: newIndexPath!.item, section: 2)
        itemChanges.append((type, indexPath, adjustedIndexPath))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        collectionView?.performBatchUpdates({
            
//            for change in self.sectionChanges {
//                switch change.type {
//                case .insert: self.collectionView?.insertSections([change.sectionIndex])
//                case .delete: self.collectionView?.deleteSections([change.sectionIndex])
//                default: break
//                }
//            }
            
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
            
//            self.sectionChanges.removeAll()
            self.itemChanges.removeAll()
            
        }, completion: { finished in
            // moved section and item changes from here
        })
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.bounds.width - 80, height: 600)
        default:
            let cellSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
            let sectionInsets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
            let viewSpacing = sectionInsets.left + sectionInsets.right + cellSpacing * 2
            let cellSize = (view.bounds.width - viewSpacing) / 3
            return CGSize(width: cellSize, height: cellSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 40, bottom: 20, right: 40)
    }
}


