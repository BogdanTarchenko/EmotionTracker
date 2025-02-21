//
//  WelcomeViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 20.02.2025.
//

import UIKit

class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let animatedBackground = AnimatedGradientView(
            frame: view.bounds,
            colors: Metrics.gradientColors,
            positions: Metrics.gradientPositions
        )
        
        view.addSubview(animatedBackground)
    }
}

private extension WelcomeViewController {
    enum Metrics {
        static let gradientColors: [UIColor] = [
            .greenPrimary,
            .bluePrimary,
            .redPrimary,
            .yellowPrimary
        ]
        
        static let gradientPositions: [(x: CGFloat, y: CGFloat, radius: CGFloat)] = [
            (-0.5, -0.5, 1400),
            (1.5, -0.5, 1400),
            (1.5, 1.5, 1400),
            (-0.5, 1.5, 1400)
        ]
    }
}
