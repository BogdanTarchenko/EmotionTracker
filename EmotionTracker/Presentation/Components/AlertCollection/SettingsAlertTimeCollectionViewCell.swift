//
//  SettingsAlertTimeCollectionViewCell.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 04.03.2025.
//

import UIKit
import SnapKit

class SettingsAlertTimeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SettingsAlertTimeCollectionViewCell"
    
    var onButtonTapped: (() -> Void)?
    
    private var timeLabel = UILabel()
    private var iconImageView = UIButton()
    
    private var iconImageViewWidthConstraint: Constraint?
    private var iconImageViewHeightConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearTimeLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if abs(bounds.height - Metrics.smallViewHeight) < 0.1 {
            contentView.layer.cornerRadius = Metrics.smallCornerRadius
            iconImageViewWidthConstraint?.update(offset: Metrics.smallIconImageSize)
            iconImageViewHeightConstraint?.update(offset: Metrics.smallIconImageSize)
        } else {
            contentView.layer.cornerRadius = Metrics.layerCornerRadius
            iconImageViewWidthConstraint?.update(offset: Metrics.iconImageSize)
            iconImageViewHeightConstraint?.update(offset: Metrics.iconImageSize)
        }
    }
}

private extension SettingsAlertTimeCollectionViewCell {
    func setupUI() {
        contentView.backgroundColor = Constants.backgroundColor
        contentView.layer.cornerRadius = Metrics.layerCornerRadius
        contentView.layer.masksToBounds = true
        
        configureTimeLabel()
        configureIconImageView()
    }
    
    func configureTimeLabel() {
        timeLabel.text = Constants.defaultTime
        timeLabel.textColor = Constants.timeLabelTextColor
        timeLabel.font = Constants.timeLabelFont
        timeLabel.textAlignment = .left
    }
    
    func configureIconImageView() {
        iconImageView.setImage(Constants.iconImage, for: .normal)
    }
    
    func setupConstraints() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.timeLabelLeadingEdgeInset)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metrics.iconImageTrailingEdgeInset)
            make.centerY.equalToSuperview()
            iconImageViewWidthConstraint = make.width.equalTo(Metrics.iconImageSize).constraint
            iconImageViewHeightConstraint = make.height.equalTo(Metrics.iconImageSize).constraint
        }
    }
    
    func setupButtonActions() {
        iconImageView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}

// MARK: - Public methods

extension SettingsAlertTimeCollectionViewCell {
    func configure(with time: String) {
        timeLabel.text = time.isEmpty ? Constants.defaultTime : time
    }
    
    func clearTimeLabel() {
        timeLabel.text = Constants.defaultTime
    }
}

// MARK: - Button Actions

private extension SettingsAlertTimeCollectionViewCell {
    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}

// MARK: - Metrics & Constants

private extension SettingsAlertTimeCollectionViewCell {
    enum Metrics {
        static let layerCornerRadius: CGFloat = 32
        static let smallCornerRadius: CGFloat = 28
        static let timeLabelLeadingEdgeInset: CGFloat = 16
        static let iconImageTrailingEdgeInset: CGFloat = 8
        static let iconImageSize: CGFloat = 48
        static let smallIconImageSize: CGFloat = 42
        static let smallViewHeight: CGFloat = 56
    }
    
    enum Constants {
        static let iconImage: UIImage = UIImage(named: "BinImg")!
        static let timeLabelTextColor: UIColor = .textPrimary
        static let timeLabelFont: UIFont = UIFont(name: "VelaSans-Regular", size: 20)!
        static let backgroundColor: UIColor = .alertTimeView
        static let defaultTime: String = "Выбрать время"
    }
}
