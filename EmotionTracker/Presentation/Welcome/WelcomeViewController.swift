//
//  WelcomeViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 20.02.2025.
//

import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    weak var coordinator: WelcomeCoordinator?
    
    private var animatedBackground: AnimatedGradientView?
    private var appleIDButton = AppleIDButton(title: Constants.appleIDButtonTitle)
    private var welcomeTitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
}

// MARK: - Setup UI & Constraints

private extension WelcomeViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        configureAnimatedBackground()
        configureAppleIDButton()
        configureWelcomeTitleLabel()
    }
    
    func configureAnimatedBackground() {
        animatedBackground = AnimatedGradientView(
            frame: view.bounds,
            colors: Metrics.gradientColors,
            positions: Metrics.gradientPositions
        )
    }
    
    func configureAppleIDButton() {
        appleIDButton.onTap = {
            self.handleAppleIDButtonTapped()
        }
        appleIDButton.accessibilityIdentifier = "AppleIDButton"
    }
    
    func configureWelcomeTitleLabel() {
        welcomeTitleLabel.text = Constants.welcomeTitle
        welcomeTitleLabel.numberOfLines = Metrics.welcomeTitleLabelNumberOfLines
        welcomeTitleLabel.textColor = Constants.titleTextColor
        welcomeTitleLabel.font = Constants.titleFont
    }
    
    func setupConstraints() {
        view.addSubview(animatedBackground!)
        view.addSubview(appleIDButton)
        view.addSubview(welcomeTitleLabel)
        
        appleIDButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.horizontalEdgesInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Metrics.appleIDButtonBottomInset)
        }
        
        welcomeTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.horizontalEdgesInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

// MARK: - Button Actions

private extension WelcomeViewController {
    @objc func handleAppleIDButtonTapped() {
        coordinator?.handleAppleIDAuthentication()
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
        static let titleFont = UIFont(name: "Gwen-Trial-Black", size: 48)
    }
}
