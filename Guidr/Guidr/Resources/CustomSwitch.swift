//
//  CustomSwitch.swift
//  Guidr
//
//  Created by Jake Connerly on 7/31/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class CustomSwitch: UISwitch {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSwitch()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSwitch()
    }
    
    func setUpSwitch() {
        
        backgroundColor = .grey
        layer.cornerRadius = 16
    }
}
