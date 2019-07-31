//
//  CreateTourViewController.swift
//  Guidr
//
//  Created by Marlon Raskin on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit
import CoreData

class CreateTourViewController: UIViewController {

	let imagePickerController = UIImagePickerController()

	var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM dd yyyy"
		return formatter
	}
    
    var tourType: String = "professional"
    
    var tourController = TourController.shared
    
    var user: UserRepresentation {
        let moc = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try moc.fetch(request)
            if let user = users.first {
                return user.userRepresentation
            }
        } catch {
            fatalError("Error performing fetch for user: \(error)")
        }
        return UserRepresentation()
    }

	@IBOutlet weak var segControl: UISegmentedControl!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var milesTextField: UITextField!
	@IBOutlet weak var summaryTextView: UITextView!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var addTourButton: UIButton!
	@IBOutlet weak var chooseDateButton: UIButton!
	@IBOutlet weak var choosePhotoButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		imagePickerController.delegate = self
		locationTextField.delegate = self
		milesTextField.delegate = self
		summaryTextView.delegate = self
		locationTextField.becomeFirstResponder()

        imageView.layer.cornerRadius = 8
		addTourButton.layer.cornerRadius = 8
		addTourButton.backgroundColor = .mainPeach
		addTourButton.tintColor = .grey
		chooseDateButton.layer.borderWidth = 2
		chooseDateButton.layer.borderColor = UIColor.mainPeach.cgColor
		chooseDateButton.layer.cornerRadius = 6
		choosePhotoButton.layer.borderWidth = 2
		choosePhotoButton.layer.borderColor = UIColor.mainPeach.cgColor
		choosePhotoButton.layer.cornerRadius = 6
		summaryTextView.layer.cornerRadius = 8
    }

	@IBAction func clearAllTapped(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Are you sure you want to clear all fields", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Clear All", style: .destructive, handler: { (clear) in
			self.clearAll()
		}))
		present(alert, animated: true, completion: nil)
	}

	@IBAction func milesFormatted(_ sender: UITextField) {
		guard let numberStr = sender.text else { return }
		let validCharacters = Set("1234567890")
		let sanitizedStr = numberStr.filter {validCharacters.contains($0)}
		guard let doubleValue = Double(sanitizedStr) else { return }
		milesTextField.text = String(format: "%.01f", doubleValue / 10)
	}

	@IBAction func segControlToggle(_ sender: UISegmentedControl) {
        if segControl.selectedSegmentIndex == 0 {
            tourType = "professional"
        } else {
            tourType = "private"
        }
	}

	@IBAction func choosePhotoTapped(_ sender: UIButton) {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			imagePickerController.sourceType = .photoLibrary
			self.present(imagePickerController, animated: true, completion: nil)
		}
	}
	
	@IBAction func addTourTapped(_ sender: UIButton) {
        addTour()
	}

	@IBAction func dismissKeyboardTapView(_ sender: UITapGestureRecognizer) {
		locationTextField.resignFirstResponder()
		milesTextField.resignFirstResponder()
		summaryTextView.resignFirstResponder()
	}
	
    
    private func addTour() {
        guard let title = locationTextField.text,
            !title.isEmpty,
            let description = summaryTextView.text,
            !description.isEmpty,
            let milesString = milesTextField.text,
            !milesString.isEmpty,
            let miles = Float(milesString),
            let date = dateLabel.text,
            !date.isEmpty else { return }
        
        tourController.createTour(title: title, description: description, miles: miles, date: "11/23/2019", userID: user.identifier!, imageURL: nil, location: title, tourType: tourType)
    }

	private func clearAll() {
		imageView.image = nil
		locationTextField.text = nil
		milesTextField.text = nil
		summaryTextView.text = nil
		dateLabel.text = nil
	}



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let datePickerVC = segue.destination as? DatePickerViewController else { return }
		datePickerVC.delegate = self
    }
}

extension CreateTourViewController: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else { return }
		imageView.image = image
		imageView.contentMode = .scaleAspectFill
		dismiss(animated: true, completion: nil)
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}

extension CreateTourViewController: DatePickerDelegate {
	func tourDateWasChosen(date: Date) {
		dateLabel.text = dateFormatter.string(from: date)
	}
}

// MARK: - UINavigationControllerDelegate
extension CreateTourViewController: UINavigationControllerDelegate {}

extension CreateTourViewController: UITextViewDelegate {
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			textView.resignFirstResponder()
			return false
		}
		return true
	}
}

extension CreateTourViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let text = textField.text,
			!text.isEmpty {
			switch textField {
			case locationTextField:
				milesTextField.becomeFirstResponder()
			case milesTextField:
				summaryTextView.becomeFirstResponder()
			default:
				textField.resignFirstResponder()
			}
		}
		return false
	}
}
