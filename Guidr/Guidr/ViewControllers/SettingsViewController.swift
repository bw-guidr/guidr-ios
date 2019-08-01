//
//  SettingsViewController.swift
//  Guidr
//
//  Created by Jake Connerly on 7/31/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

	@IBOutlet weak var appInfoLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else { return }
		guard let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") else { return }

		appInfoLabel.text = "Version: \(version) ⌇ Build: \(buildNumber)"

    }
}
