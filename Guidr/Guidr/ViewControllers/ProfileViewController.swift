//
//  ProfileViewController.swift
//  Guidr
//
//  Created by Marlon Raskin on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class ProfileViewController: UICollectionViewController {

	var tourPhotos: [UIImage] = [UIImage(named: "bearVector")!, UIImage(named: "hikeVector")!, UIImage(named: "MountainRedVector")!, UIImage(named: "treeAndMoonVector")!, UIImage(named: "MountainVector")!]

	let miles = "272"
	let tours = "15"
	let locations = "9"



    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.barTintColor = .black
		tabBarController?.tabBar.tintColor = .mainPeach
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		default:
			return tourPhotos.count
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
		cell.nameLabel.text = "Emilio Montoya"
		cell.profileImageView.image = UIImage(named: "profilePhoto")

		return cell
	}

	private func tourPhotoCell(from cell: UICollectionViewCell, atIndex index: Int) -> TourPhotoCollectionViewCell {
		guard let cell = cell as? TourPhotoCollectionViewCell else { return TourPhotoCollectionViewCell() }
		cell.tourImageView.backgroundColor = UIColor(hue: CGFloat.random(in: 0...1), saturation: 0.8, brightness: 0.7, alpha: 1)

		return cell
	}
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		switch indexPath.section {
		case 0:
			return CGSize(width: view.bounds.width, height: 600)
		default:
			return CGSize(width: 110, height: 110)
		}
	}
}
