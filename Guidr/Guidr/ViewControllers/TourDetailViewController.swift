//
//  TourDetailViewController.swift
//  Guidr
//
//  Created by Jake Connerly on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit
import FirebaseUI

class TourDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var tourNameLabel: UILabel!
    @IBOutlet weak var tourDataLabel: UILabel!
    @IBOutlet weak var tourMilesLabel: UILabel!
    @IBOutlet weak var personalLabel: UILabel!
    @IBOutlet weak var tourDetailTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var viewForMap: UIView!


	let generator = UIImpactFeedbackGenerator(style: .medium)
    let tourController: TourController = TourController.shared
	var tour: Tour?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designSetup()

		scrollView.delegate = self
		generator.prepare()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }
    @IBAction func arrowTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        guard let tour = tour else { return }
		let alert = UIAlertController(title: "Are you sure you want to delete this tour?", message: "It cannot be recovered once this action is completed", preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let deleteAction = UIAlertAction(title: "Delete Tour", style: .destructive) { (delete) in
			self.tourController.deleteTour(tour: tour)
			self.dismiss(animated: true, completion: nil)
		}
		[cancelAction, deleteAction].forEach { alert.addAction($0) }
		present(alert, animated: true, completion: nil)
    }
    
    func designSetup() {
        scrollView.contentInsetAdjustmentBehavior = .never
        detailImageView.layer.cornerRadius = 30
        detailImageView.clipsToBounds = true
		viewForMap.layer.cornerRadius = 15
    }
    
    func updateViews() {
        guard let tour = tour else { return }
        
        tourNameLabel.text = tour.title?.uppercased()
        tourDetailTextView.text = tour.summary
        tourDataLabel.text = tour.date?.uppercased()
        tourMilesLabel.text = "\(tour.miles) MILES"
        personalLabel.text = tour.tourType?.uppercased()
        
        guard let imageURL = tour.imageURL else { return }
        let imageRef = Storage.storage().reference(forURL: imageURL)
        detailImageView.sd_setImage(with: imageRef)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditTourSegue" {
            print(segue.destination.children)
            guard let editTourVC = segue.destination.children.first as? CreateTourViewController else { return }
            editTourVC.tour = tour
			editTourVC.delegate = self
        }
    }
}

extension TourDetailViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y <= -160 {
			generator.impactOccurred()
			dismiss(animated: true)
		}
	}
}

extension TourDetailViewController: CreateTourViewControllerDelegate {
	func createTourViewController(_ createTourViewController: CreateTourViewController, didEditTour tour: Tour) {
		updateViews()
	}
}
