//
//  AppearanceHelper.swift
//  Guidr
//
//  Created by Sean Acres on 8/1/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import UIKit

enum AppearanceHelper {
    static func bebasFont(with textStyle: UIFont.TextStyle, pointSize: CGFloat) -> UIFont {
        let font = UIFont(name: "Bebas Neue", size: pointSize)!
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
    
    
    
    static func setAppearance() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.offBlack, NSAttributedString.Key.font: bebasFont(with: .largeTitle, pointSize: 40)]
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
}
