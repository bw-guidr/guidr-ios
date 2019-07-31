//
//  DatePickerViewController.swift
//  Guidr
//
//  Created by Marlon Raskin on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

protocol DatePickerDelegate: AnyObject {
	func tourDateWasChosen(date: Date)
}

class DatePickerViewController: UIViewController {

	weak var delegate: DatePickerDelegate?

	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var selectDateButton: UIButton!
	@IBOutlet weak var modalView: UIView!


	override func viewDidLoad() {
        super.viewDidLoad()
		modalView.layer.cornerRadius = 30
		modalView.layer.shadowRadius = 12
		modalView.layer.shadowOffset = .zero
		modalView.layer.shadowColor = UIColor.black.cgColor
		modalView.layer.shadowOpacity = 0.3
    }

	@IBAction func blankSpaceTapped(_ sender: UITapGestureRecognizer) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func cancelTapped(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func selectDateTapped(_ sender: UIButton) {
		self.delegate?.tourDateWasChosen(date: datePicker.date)
		dismiss(animated: true, completion: nil)
	}
}
