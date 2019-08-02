//
//  CustomButton.swift
//  Guidr
//
//  Created by Jake Connerly on 7/31/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class BigCustomButton: UIButton {

	override var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [.allowUserInteraction], animations: {
				self.transform = self.isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
			}, completion: nil)
		}
	}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpButton()
    }
    
    func setUpButton() {
        setTitleColor(.grey, for: .normal)
		contentEdgeInsets = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40)
        backgroundColor = .secondaryOrange
        titleLabel?.font = UIFont(name: "Montserrat", size: 14)
        layer.cornerRadius = 19
    }
}
