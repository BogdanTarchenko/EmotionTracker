//
//  WelcomeViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 20.02.2025.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension WelcomeViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        let animatedBackground = AnimatedGradientView(
            frame: view.bounds,
            colors: Metrics.gradientColors,
            positions: Metrics.gradientPositions
        )
        
        view.addSubview(animatedBackground)
        
        let appleIDButton = AppleIDButton(title: Constants.appleIDButtonTitle)
        
        view.addSubview(appleIDButton)
        
        appleIDButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.horizontalEdgesInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Metrics.appleIDButtonBottomInset)
        }
        
        let welcomeTitleLabel: UILabel = {
            let label = UILabel()
            label.text = Constants.welcomeTitle
            label.numberOfLines = Metrics.welcomeTitleLabelNumberOfLines
            label.textColor = Constants.titleTextColor
            label.font = Constants.titleFont
            return label
        }()
        
        view.addSubview(welcomeTitleLabel)
        
        welcomeTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.horizontalEdgesInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Metrics.welcomeTitleLabelTopInset)
        }
    }
}

// MARK: - Metrics & Constants

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
        
        static let horizontalEdgesInset: CGFloat = 24
        static let appleIDButtonBottomInset: CGFloat = 24
        static let welcomeTitleLabelTopInset: CGFloat = 24
        static let welcomeTitleLabelNumberOfLines: Int = 2
    }
    
    enum Constants {
        static let appleIDButtonTitle: String = LocalizedKey.Welcome.appleIDButtonTitle
        static let welcomeTitle: String = LocalizedKey.Welcome.welcomeTitle
        static let titleTextColor: UIColor = UIColor.textSecondary
        static let titleFont = UIFont.systemFont(ofSize: 48, weight: .bold)
    }
}
