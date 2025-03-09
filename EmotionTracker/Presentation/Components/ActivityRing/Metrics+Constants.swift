//
//  ActivityRingMetrics.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 23.02.2025.
//

import Foundation
import UIKit

extension ActivityRingView {
    enum Metrics {
        static let ringWidth: CGFloat = 24
        
        enum Animation {
            static let rotationDuration: TimeInterval = 6
        }
        
        enum Gradient {
            static let locations: [NSNumber] = [0.08, 0.35, 0.9, 1.0]
            static let startPoint = CGPoint(x: 0.5, y: 0)
            static let endPoint = CGPoint(x: 0.5, y: 1)
        }
        
        enum SegmentGradient {
            static let locations: [NSNumber] = [0.0, 1.0]
            static let startPoint = CGPoint(x: 0.5, y: 0.0)
            static let endPoint = CGPoint(x: 0.5, y: 1.0)
            static let brightenValue: CGFloat = 0.2
        }
        
        enum CapEnds {
            static let capAngleSize: CGFloat = 0.01
            static let completeRingThreshold: CGFloat = 0.99
        }
    }
}
