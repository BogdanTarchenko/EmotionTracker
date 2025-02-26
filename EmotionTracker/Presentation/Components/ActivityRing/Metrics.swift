//
//  ActivityRingMetrics.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 23.02.2025.
//

import Foundation

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
    }
}
