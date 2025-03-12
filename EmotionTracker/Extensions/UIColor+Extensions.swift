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
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
