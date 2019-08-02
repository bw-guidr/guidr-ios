//
//  CustomSmallButton.swift
//  Guidr
//
//  Created by Marlon Raskin on 8/2/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class SmallCustomButton: UIButton {

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
		setTitleColor(.offBlack, for: .normal)
		contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
		backgroundColor = .offWhite
		layer.borderWidth = 1
		layer.borderColor = UIColor.mainPeach.cgColor
		layer.cornerRadius = 14
	}
}
