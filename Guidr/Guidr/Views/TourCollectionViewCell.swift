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
    
    var tour: Tour? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        updateStyle()
        guard let tour = tour else { return }
        tourNameLabel.text = tour.title
    }
    
    private func updateStyle() {
        tourImageView.layer.cornerRadius = 30
        tourImageView.clipsToBounds = true
        labelView.layer.cornerRadius = 20
        labelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cellView.layer.shadowOpacity = 0.8
        cellView.layer.shadowRadius = 8
        cellView.layer.shadowOffset = .zero
        cellView.layer.cornerRadius = 30
        layer.cornerRadius = 30
        clipsToBounds = false
        layer.masksToBounds = false
    }
    
}


