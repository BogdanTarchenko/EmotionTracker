//
//  DefaultNavBar.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import UIKit
import SnapKit

class DefaultNavBar: UIView {
    
    private var backButton = UIButton()
    private var titleLabel = UILabel()
    
    var onButtonTapped: (() -> Void)?
    
    init(title: String?) {
        super.init(frame: .zero)
        setupUI(title: title)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DefaultNavBar {
    func setupUI(title: String?) {
        configureBackButton()
        configureTitleLabel(title: title)
    }
    
    func configureBackButton() {
        backButton.setImage(Constants.backButtonImage, for: .normal)
        backButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configureTitleLabel(title: String?) {
        if let title {
            titleLabel.text = title
            titleLabel.font = Constants.titleLabelFont
            titleLabel.textColor = Constants.titleLabelTextColor
            titleLabel.textAlignment = .left
        }
    }
    
    func setupConstraints() {
        addSubview(backButton)
        addSubview(titleLabel)
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.size.equalTo(Metrics.backButtonSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(Metrics.titleLabelLeadingEdgeOffset)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Button Actions

private extension DefaultNavBar {
    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}

// MARK: - Metrics & Constants

private extension DefaultNavBar {
    enum Metrics {
        static let backButtonSize: CGFloat = 40
        static let titleLabelLeadingEdgeOffset: CGFloat = 16
    }
    
    enum Constants {
        static let titleLabelTextColor: UIColor = .textPrimary
        static let titleLabelFont: UIFont = UIFont(name: "Gwen-Trial-Regular", size: 24)!
        static let backButtonImage: UIImage = UIImage(named: "BackButtonImg")!
    }
}
