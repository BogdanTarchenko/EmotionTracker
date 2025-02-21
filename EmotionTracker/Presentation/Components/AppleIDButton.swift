//
//  AppleIDButton.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 21.02.2025.
//


import UIKit
import SnapKit

class AppleIDButton: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: Constants.appleLogoImageName)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.titleTextColor
        label.font = Constants.titleFont
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        
        backgroundColor = Constants.buttonBackgroundColor
        layer.cornerRadius = Metrics.buttonCornerRadius
        layer.masksToBounds = true
        
        titleLabel.text = title
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Metrics.buttonHeight)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.iconLeadingInset)
            make.centerY.equalToSuperview()
            make.width.equalTo(Metrics.iconWidth)
            make.height.equalTo(Metrics.iconHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(Metrics.titleLeadingOffset)
            make.trailing.equalToSuperview().inset(Metrics.titleTrailingInset)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Metrics & Constants

private struct Metrics {
    static let buttonHeight: CGFloat = 80
    static let buttonCornerRadius: CGFloat = 40
    static let iconLeadingInset: CGFloat = 24
    static let iconWidth: CGFloat = 42
    static let iconHeight: CGFloat = 48
    static let titleLeadingOffset: CGFloat = 16
    static let titleTrailingInset: CGFloat = 24
}

private struct Constants {
    static let appleLogoImageName = "AppleLogo"
    static let buttonBackgroundColor = UIColor.buttonPrimary
    static let titleTextColor = UIColor.textSecondary
    static let titleFont = UIFont(name: "VelaSans-Medium", size: 16)
}
