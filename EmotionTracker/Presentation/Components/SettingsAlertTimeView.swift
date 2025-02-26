//
//  SettingsAlertTimeView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import UIKit
import SnapKit

class SettingsAlertTimeView: UIView {
    
    private var timeLabel = UILabel()
    private var iconImageView = UIButton()
    
    init(time: String) {
        super.init(frame: .zero)
        setupUI(time: time)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingsAlertTimeView {
    func setupUI(time: String) {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Metrics.layerCornerRadius
        layer.masksToBounds = true
        
        configureTimeLabel(time: time)
        configureIconImageView()
    }
    
    func configureTimeLabel(time: String) {
        timeLabel.text = time
        timeLabel.textColor = Constants.timeLabelTextColor
        timeLabel.font = Constants.timeLabelFont
        timeLabel.textAlignment = .left
    }
    
    func configureIconImageView() {
        iconImageView.setImage(Constants.iconImage, for: .normal)
    }
    
    func setupConstraints() {
        self.addSubview(timeLabel)
        self.addSubview(iconImageView)
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.timeLabelLeadingEdgeInset)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metrics.iconImageTrailingEdgeInset)
            make.centerY.equalToSuperview()
            make.size.equalTo(Metrics.iconImageSize)
        }
    }
}

// MARK: - Metrics & Constants

private extension SettingsAlertTimeView {
    enum Metrics {
        static let layerCornerRadius: CGFloat = 32
        static let timeLabelLeadingEdgeInset: CGFloat = 16
        static let iconImageTrailingEdgeInset: CGFloat = 8
        static let iconImageVerticalInset: CGFloat = 8
        static let iconImageSize: CGFloat = 48
    }

    enum Constants {
        static let iconImage: UIImage = UIImage(named: "BinImg")!
        static let timeLabelTextColor: UIColor = .textPrimary
        static let timeLabelFont: UIFont = UIFont(name: "VelaSans-Regular", size: 20)!
        static let backgroundColor: UIColor = .alertTimeView
    }
}
