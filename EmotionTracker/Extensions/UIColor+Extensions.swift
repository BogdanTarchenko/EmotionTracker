//
//  UIColor+Extensions.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 05.03.2025.
//

import UIKit

extension EmotionColor {
    static func from(uiColor: UIColor) -> EmotionColor? {
        switch uiColor {
        case .greenPrimary:
            return .green
        case .redPrimary:
            return .red
        case .yellowPrimary:
            return .yellow
        case .bluePrimary:
            return .blue
        default:
            return nil
        }
    }
    
    func toUIColor() -> UIColor {
        switch self {
        case .green:
            return .greenPrimary
        case .red:
            return .redPrimary
        case .yellow:
            return .yellowPrimary
        case .blue:
            return .bluePrimary
        }
    }
}

extension UIColor {
    func lighten(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(
            red: min(red + percentage, 1.0),
            green: min(green + percentage, 1.0),
            blue: min(blue + percentage, 1.0),
            alpha: alpha
        )
    }
}
