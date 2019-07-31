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
        tourImageView.clipsToBounds      = true
        labelView.layer.cornerRadius     = 20
        layer.borderColor                = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1).cgColor
        layer.borderWidth                = 0.8
        layer.cornerRadius               = 30
    }
    
}


