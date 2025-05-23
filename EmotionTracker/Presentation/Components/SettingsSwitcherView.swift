//
//  SettingsSwitcherView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 26.02.2025.
//

import UIKit
import SnapKit

class SettingsSwitcherView: UIView {
    // MARK: - Properties
    
    private var iconImageView = UIImageView()
    private var titleLabel = UILabel()
    private var switcher = UISwitch()
    
    var onSwitchChanged: ((Bool) -> Void)?
    
    // MARK: - Initialization
    
    init(image: UIImage, title: String) {
        super.init(frame: .zero)
        setupUI(image: image, title: title)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setSwitchState(_ isOn: Bool) {
        switcher.setOn(isOn, animated: true)
    }
    
    func getSwitchState() -> Bool {
        return switcher.isOn
    }
}

// MARK: - Private Setup

private extension SettingsSwitcherView {
    func setupUI(image: UIImage, title: String) {
        configureIconImageView(image: image)
        configureTitleLabel(title: title)
        configureSwitcher()
    }
    
    func configureIconImageView(image: UIImage) {
        iconImageView.image = image
        iconImageView.tintColor = Constants.iconImageColor
    }
    
    func configureTitleLabel(title: String) {
        titleLabel.text = title
        titleLabel.textColor = Constants.titleLabelTextColor
        titleLabel.font = Constants.titleLabelFont
        titleLabel.textAlignment = .left
    }
    
    func configureSwitcher() {
        switcher.isOn = false
        switcher.onTintColor = Constants.switcherOnTintColor
        switcher.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        onSwitchChanged?(sender.isOn)
    }
    
    func setupConstraints() {
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(switcher)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(Metrics.iconImageViewSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(Metrics.titleLabelLeadingEdgeOffset)
            make.centerY.equalToSuperview()
        }
        
        switcher.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(Metrics.switcherHeight)
            make.width.equalTo(Metrics.switcherWidth)
        }
    }
}

// MARK: - Metrics & Constants

private extension SettingsSwitcherView {
    enum Metrics {
        static let iconImageViewSize: CGFloat = 24
        static let titleLabelLeadingEdgeOffset: CGFloat = 8
        static let switcherHeight: CGFloat = 32
        static let switcherWidth: CGFloat = 52
    }
    
    enum Constants {
        static let iconImageColor: UIColor = .iconPrimary
        static let titleLabelTextColor: UIColor = .textPrimary
        static let titleLabelFont: UIFont = UIFont(name: "VelaSans-Medium", size: 16)!
        static let switcherOnTintColor: UIColor = .greenPrimary
    }
}
