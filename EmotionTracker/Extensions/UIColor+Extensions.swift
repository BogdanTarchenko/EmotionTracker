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
