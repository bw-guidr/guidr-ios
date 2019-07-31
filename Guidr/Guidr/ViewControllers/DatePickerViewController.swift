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


	override func viewDidLoad() {
        super.viewDidLoad()

    }


	@IBAction func cancelTapped(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func selectDateTapped(_ sender: UIButton) {
		self.delegate?.tourDateWasChosen(date: datePicker.date)
		dismiss(animated: true, completion: nil)
	}
}
