//
//  TourDetailViewController.swift
//  Guidr
//
//  Created by Jake Connerly on 7/30/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class TourDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var tourNameLabel: UILabel!
    @IBOutlet weak var tourDataLabel: UILabel!
    @IBOutlet weak var tourMilesLabel: UILabel!
    @IBOutlet weak var personalLabel: UILabel!
    @IBOutlet weak var tourDetailTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!

	let generator = UIImpactFeedbackGenerator(style: .medium)
    var tour: Tour?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designSetup()

		scrollView.delegate = self
		generator.prepare()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func designSetup() {
        scrollView.contentInsetAdjustmentBehavior = .never
        detailImageView.layer.cornerRadius = 30
        detailImageView.clipsToBounds = true
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

extension TourDetailViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y <= -160 {
			generator.impactOccurred()
			dismiss(animated: true)
		}
	}
}
