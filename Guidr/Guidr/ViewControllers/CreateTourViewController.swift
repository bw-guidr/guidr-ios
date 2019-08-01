//
//  CreateTourViewController.swift
//  Guidr
//
//  Created by Marlon Raskin on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit
import CoreData

protocol CreateTourViewControllerDelegate: AnyObject {
	func createTourViewController(_ createTourViewController: CreateTourViewController, didEditTour tour: Tour)
}

class CreateTourViewController: UIViewController {

	let imagePickerController = UIImagePickerController()

	weak var delegate: CreateTourViewControllerDelegate?

	var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM dd yyyy"
		return formatter
	}
    
    enum TourType: String {
        case personal
        case professional
    }
    
    var tourType: TourType = .professional
    var tourController = TourController.shared
    var tour: Tour?
    
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
	@IBOutlet weak var clearButton: UIBarButtonItem!

	override func viewDidLoad() {
        super.viewDidLoad()

		imagePickerController.delegate = self
		locationTextField.delegate = self
		milesTextField.delegate = self
		summaryTextView.delegate = self
		locationTextField.becomeFirstResponder()
		setupUIElements()
        updateViews()

    }


	@IBAction func clearAllTapped(_ sender: UIBarButtonItem) {
		// Confirms that at least 1 field has a value first, otherwise it won't do anything
		guard locationTextField.text?.isEmpty == false ||
			milesTextField.text?.isEmpty == false ||
			summaryTextView.text.isEmpty == false ||
			dateLabel.text?.isEmpty == false ||
			imageView?.image != nil else { return }

		let alert = UIAlertController(title: "Are you sure you want to clear all fields?", message: nil, preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let clearAllAction = UIAlertAction(title: "Clear All", style: .destructive) { (clear) in
			self.clearAll()
		}
		[cancelAction, clearAllAction].forEach { alert.addAction($0) }
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
            tourType = .professional
        } else {
            tourType = .personal
        }
	}

	@IBAction func choosePhotoTapped(_ sender: UIButton) {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			imagePickerController.sourceType = .photoLibrary
			self.present(imagePickerController, animated: true, completion: nil)
		}
	}
	
	@IBAction func addTourTapped(_ sender: UIButton) {
        addEditTour()
	}

	@IBAction func dismissKeyboardTapView(_ sender: UITapGestureRecognizer) {
		locationTextField.resignFirstResponder()
		milesTextField.resignFirstResponder()
		summaryTextView.resignFirstResponder()
	}
	
    
    private func addEditTour() {
        guard let title = locationTextField.text,
            !title.isEmpty,
            let description = summaryTextView.text,
            !description.isEmpty,
            let milesString = milesTextField.text,
            !milesString.isEmpty,
            let miles = Float(milesString),
            let date = dateLabel.text,
            !date.isEmpty else { return }
        
        if let tour = tour {
            tourController.updateTour(tour: tour, title: title, description: description, miles: miles, imageURL: nil, date: date, tourType: tourType.rawValue)
			delegate?.createTourViewController(self, didEditTour: tour)
			self.dismiss(animated: true, completion: nil)
        } else {
            tourController.createTour(title: title, description: description, miles: miles, date: date, userID: user.identifier!, imageURL: nil, location: title, tourType: tourType.rawValue)
			self.tabBarController?.selectedIndex = 0
        }
    }

	private func clearAll() {
		imageView.image = nil
		locationTextField.text = nil
		milesTextField.text = nil
		summaryTextView.text = nil
		dateLabel.text = nil
	}

	private func setupUIElements() {
		imageView.layer.cornerRadius = 8
		addTourButton.layer.cornerRadius = 19
		addTourButton.backgroundColor = .mainPeach
		addTourButton.tintColor = .grey
		chooseDateButton.layer.borderWidth = 2
		chooseDateButton.layer.borderColor = UIColor.mainPeach.cgColor
		chooseDateButton.backgroundColor = .offWhite
		chooseDateButton.layer.cornerRadius = 12
		choosePhotoButton.layer.borderWidth = 2
		choosePhotoButton.layer.borderColor = UIColor.mainPeach.cgColor
		choosePhotoButton.backgroundColor = .offWhite
		choosePhotoButton.layer.cornerRadius = 12
		summaryTextView.layer.cornerRadius = 8
		summaryTextView.layer.borderWidth = 1
		summaryTextView.layer.borderColor = #colorLiteral(red: 0.9115869483, green: 0.9115869483, blue: 0.9115869483, alpha: 1)
		summaryTextView.textContainerInset = UIEdgeInsets(top: 8,left: 5,bottom: 8,right: 5); // top, left, bottom, right
	}


    
    private func updateViews() {
        if let tour = tour {
            locationTextField.text = tour.title
            summaryTextView.text = tour.summary
            milesTextField.text = "\(tour.miles)"
            dateLabel.text = tour.date
            
            if tour.tourType == "professional" {
                tourType = .professional
            } else {
                tourType = .personal
            }
            
            addTourButton.setTitle("Edit Tour", for: .normal)
        }
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
