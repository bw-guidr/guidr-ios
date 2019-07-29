//
//  ProfileViewController.swift
//  Guidr
//
//  Created by Marlon Raskin on 7/29/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.tintColor = .mainPeach
		tableView.separatorStyle = .none
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
