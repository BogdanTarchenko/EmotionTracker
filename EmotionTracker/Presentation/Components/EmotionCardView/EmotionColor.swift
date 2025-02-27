//
//  EmotionColor.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import UIKit

enum EmotionColor {
    case green
    case red
    case yellow
    case blue
    
    var gradientColors: [CGColor] {
        switch self {
        case .green:
            return [UIColor(red: 0/255, green: 255/255, blue: 85/255, alpha: 1).cgColor,
                    UIColor(red: 0/255, green: 255/255, blue: 85/255, alpha: 0).cgColor]
        case .red:
            return [UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor,
                    UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0).cgColor]
        case .yellow:
            return [UIColor(red: 255/255, green: 170/255, blue: 0/255, alpha: 1).cgColor,
                    UIColor(red: 255/255, green: 170/255, blue: 0/255, alpha: 0).cgColor]
        case .blue:
            return [UIColor(red: 0/255, green: 170/255, blue: 255/255, alpha: 1).cgColor,
                    UIColor(red: 0/255, green: 170/255, blue: 255/255, alpha: 0).cgColor]
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .green:
            return UIColor.greenPrimary
        case .red:
            return UIColor.redPrimary
        case .yellow:
            return UIColor.yellowPrimary
        case .blue:
            return UIColor.bluePrimary
        }
    }
}
