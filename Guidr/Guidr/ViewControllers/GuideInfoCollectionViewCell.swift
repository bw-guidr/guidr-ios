//
//  GuideInfoCollectionViewCell.swift
//  Guidr
//
//  Created by Marlon Raskin on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class GuideInfoCollectionViewCell: UICollectionViewCell {


	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var tourCountLabel: UILabel!
	@IBOutlet weak var milesCountLabel: UILabel!
	@IBOutlet weak var locationsCountLabel: UILabel!
	@IBOutlet weak var viewForPhoto: UIView!

	override func awakeFromNib() {
		super.awakeFromNib()

		viewForPhoto.layer.cornerRadius = 30
//		viewForPhoto.layer.sha
	}
	
}
