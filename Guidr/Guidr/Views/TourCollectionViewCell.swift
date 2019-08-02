//
//  TourCollectionViewCell.swift
//  Guidr
//
//  Created by Jake Connerly on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class TourCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Setting Label Frame
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tourNameLabel: UILabel!
    @IBOutlet weak var tourImageView: UIImageView!
    @IBOutlet weak var labelView: UIView!
	@IBOutlet weak var viewForCellContents: UIView!

    var tour: Tour? {
        didSet {
            updateViews()
        }
    }

	override var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [.allowUserInteraction], animations: {
				self.transform = self.isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
			}, completion: nil)
		}
	}
    
    private func updateViews() {
        updateStyle()
        guard let tour = tour else { return }
        tourNameLabel.text = tour.title
    }
    
    private func updateStyle() {
		viewForCellContents.layer.cornerRadius = 10
        tourImageView.clipsToBounds = true
		tourNameLabel.textColor = .offWhite
		labelView.backgroundColor = .offBlack
//        labelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cellView.layer.shadowOpacity = 0.4
		cellView.layer.shadowColor = #colorLiteral(red: 0.2124917535, green: 0.271030252, blue: 0.3560721495, alpha: 1)
        cellView.layer.shadowRadius = 10
        cellView.layer.shadowOffset = .zero
        cellView.layer.cornerRadius = 30
        layer.cornerRadius = 30
        clipsToBounds = false
        layer.masksToBounds = false
    }
}


