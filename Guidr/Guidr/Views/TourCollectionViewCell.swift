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
    
    @IBOutlet weak var tourNameLabel: UILabel!
    
    var tour: Tour? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Setting Cell Frame
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 10
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateViews() {
        guard let tour = tour else { return }
        tourNameLabel.text = tour.title
    }
    
}


