//
//  AppColors.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 30/01/23.
//

import UIKit
enum AppColors: String {
    // background Color
    case background
    case secondaryBackground
    
    // foreground color
    case label
    case secondaryLabel
    case green
    case red
}

extension UIColor {
    static func color(from appColor: AppColors) -> UIColor? {
        return UIColor(named: appColor.rawValue)
    }
}
