//
//  ProfileViewController.swift
//  Guidr
//
//  Created by Marlon Raskin on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UICollectionViewController {

    let tourController = TourController()
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
    
    
//    lazy var fetchedResultsController: NSFetchedResultsController<Tour> = {
//        let fetchRequest: NSFetchRequest<Tour> = Tour.fetchRequest()
//
//        // FRCs need at least one sort descriptor. If you are using "sectionNameKeyPath", the first sort descriptor must be the same attribute
//        let dateDescriptor = NSSortDescriptor(key: "date", ascending: true)
//        let titleDescriptor = NSSortDescriptor(key: "title", ascending: false)
//        fetchRequest.sortDescriptors = [dateDescriptor, titleDescriptor]
//
//        let moc = CoreDataStack.shared.mainContext
//
//        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "date", cacheName: nil)
//
//        frc.delegate = self
//
//        do {
//            try frc.performFetch()
//        } catch {
//            fatalError("Error performing fetch for frc: \(error)")
//        }
//
//        return frc
//    }()
    
	var tourPhotos: [UIImage] = [UIImage(named: "bearVector")!, UIImage(named: "hikeVector")!, UIImage(named: "MountainRedVector")!, UIImage(named: "treeAndMoonVector")!, UIImage(named: "MountainVector")!]

	let miles = "272"
	let tours = "15"
	let locations = "9"
    
    let token: String? = KeychainWrapper.standard.string(forKey: "token")


    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.barTintColor = .black
		tabBarController?.tabBar.tintColor = .mainPeach
        
        // check if first launch or not logged in
        if UserDefaults.isFirstLaunch() && token == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else if token == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        tourController.fetchToursFromServer(userID: user.identifier!)
//    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
			return tourPhotos.count * 3
		}
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		switch indexPath.section {
		case 0:
			return guideInfoCell(from: collectionView.dequeueReusableCell(withReuseIdentifier: "GuideInfoCell", for: indexPath), atIndex: indexPath.item)
		default:
			return tourPhotoCell(from: collectionView.dequeueReusableCell(withReuseIdentifier: "TourPhotoCell", for: indexPath), atIndex: indexPath.item)
		}
    }

	private func guideInfoCell(from cell: UICollectionViewCell, atIndex index: Int) -> GuideInfoCollectionViewCell {
		guard let cell = cell as? GuideInfoCollectionViewCell else { return GuideInfoCollectionViewCell() }
		cell.milesCountLabel.text = miles
		cell.locationsCountLabel.text = locations
		cell.nameLabel.text = user.name
		cell.profileImageView.image = UIImage(named: "profilePhoto")

		return cell
	}

	private func tourPhotoCell(from cell: UICollectionViewCell, atIndex index: Int) -> TourPhotoCollectionViewCell {
		guard let cell = cell as? TourPhotoCollectionViewCell else { return TourPhotoCollectionViewCell() }
		cell.tourImageView.image = tourPhotos.randomElement()

		return cell
	}
    
    // MARK - NSFetchedResultsDelegate
    
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


