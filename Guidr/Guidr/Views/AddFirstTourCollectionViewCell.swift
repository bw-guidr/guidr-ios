//
//  AddFirstTourCollectionViewCell.swift
//  Guidr
//
//  Created by Marlon Raskin on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class AddFirstTourCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var noToursLabel: UILabel!
	@IBOutlet weak var addTourButton: UIButton!


	override func awakeFromNib() {
		super.awakeFromNib()
		noToursLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
	}
}


