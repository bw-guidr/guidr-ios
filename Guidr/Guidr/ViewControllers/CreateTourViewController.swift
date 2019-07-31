//
//  CreateTourViewController.swift
//  Guidr
//
//  Created by Marlon Raskin on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class CreateTourViewController: UIViewController {

	let imagePickerController = UIImagePickerController()

	var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM dd yyyy"
		return formatter
	}

	@IBOutlet weak var segControl: UISegmentedControl!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var milesTextField: UITextField!
	@IBOutlet weak var summaryTextView: UITextView!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var addTourButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = 8
    }

	
	@IBAction func segControlToggle(_ sender: UISegmentedControl) {

	}

	@IBAction func choosePhotoTapped(_ sender: UIButton) {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			imagePickerController.sourceType = .photoLibrary
			self.present(imagePickerController, animated: true, completion: nil)
		}
	}
	
	@IBAction func addTourTapped(_ sender: UIButton) {

	}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateTourViewController: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { return }
		imageView.image = image
		imageView.contentMode = .scaleAspectFill
		dismiss(animated: true, completion: nil)
	}
}

extension CreateTourViewController: DatePickerDelegate {
	func tourDateWasChosen(date: Date) {
		dateLabel.text = dateFormatter.string(from: date)
	}
}
