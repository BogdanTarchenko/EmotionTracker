//
//  AddAlertButton.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import UIKit
import SnapKit

class AddAlertButton: UIButton {
    
    var onButtonTapped: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
            }
        }
    }
}

private extension AddAlertButton {
    func setupUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Metrics.layerCornerRadius
        layer.masksToBounds = true
        
        configureTitleLabel()
    }
    
    func configureTitleLabel() {
        setTitle(Constants.titleLabelText, for: .normal)
        setTitleColor(Constants.titleLabelTextColor, for: .normal)
        titleLabel?.font = Constants.titleLabelFont
        titleLabel?.textAlignment = .center
    }
    
    func setupButtonActions() {
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}

// MARK: - Button Actions

private extension AddAlertButton {
    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}

// MARK: - Metrics & Constants

private extension AddAlertButton {
    enum Metrics {
        static let layerCornerRadius: CGFloat = 28
    }
    
    enum Constants {
        static let titleLabelText: String = LocalizedKey.Settings.addAlertText
        static let titleLabelTextColor: UIColor = .textSecondary
        static let titleLabelFont: UIFont = UIFont(name: "VelaSans-Medium", size: 16)!
        static let backgroundColor: UIColor = .buttonPrimary
    }
}
