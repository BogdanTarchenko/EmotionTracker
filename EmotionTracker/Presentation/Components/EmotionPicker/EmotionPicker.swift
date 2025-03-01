//
//  EmotionPicker.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit
import SnapKit

class EmotionPicker: UIView {
    
    var onButtonTapped: (() -> Void)?
    
    private var state: EmotionPickerState {
        didSet {
            updateUI()
        }
    }
    
    private var pickEmotionTitleLabel = UILabel()
    private var pickEmotionButton = UIButton()
    private var emotionTitleLabel = UILabel()
    private var emotionDescriptionLabel = UILabel()
    
    
    init(state: EmotionPickerState) {
        self.state = state
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        setupButtonActions()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmotionPicker {
    func setupUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Metrics.layerCornerRadius
        layer.masksToBounds = true
        
        configurePickEmotionTitleLabel()
        configureEmotionTitleLabel()
        configureEmotionDescription()
    }
    
    func configurePickEmotionTitleLabel() {
        pickEmotionTitleLabel.text = Constants.pickEmotionTitle
        pickEmotionTitleLabel.textColor = Constants.pickEmotionTitleColor
        pickEmotionTitleLabel.font = Constants.pickEmotionTitleFont
        pickEmotionTitleLabel.numberOfLines = 2
    }
    
    func configureEmotionTitleLabel() {
        emotionTitleLabel.font = Constants.emotionTitleFont
    }
    
    func configureEmotionDescription() {
        emotionDescriptionLabel.font = Constants.emotionDescriptionFont
        emotionDescriptionLabel.textColor = Constants.emotionDescriptionColor
        emotionDescriptionLabel.numberOfLines = 2
    }
    
    func setupConstraints() {
        addSubview(pickEmotionTitleLabel)
        addSubview(pickEmotionButton)
        addSubview(emotionTitleLabel)
        addSubview(emotionDescriptionLabel)
        
        pickEmotionTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalTo(pickEmotionButton.snp.leading).offset(-16)
        }
        
        pickEmotionButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(8)
            make.size.equalTo(64)
        }
        
        emotionTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(22)
        }
        
        emotionDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(emotionTitleLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(22)
        }
    }
    
    func setupButtonActions() {
        pickEmotionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func updateUI() {
        switch state {
        case .inactive:
            pickEmotionTitleLabel.isHidden = false
            pickEmotionButton.isHidden = false
            emotionTitleLabel.isHidden = true
            emotionDescriptionLabel.isHidden = true
            
            pickEmotionButton.setImage(Constants.pickEmotionButtonInactiveImage, for: .normal)
        case .active(let emotionTitle, let emotionDescription, let emotionColor):
            pickEmotionTitleLabel.isHidden = true
            pickEmotionButton.isHidden = false
            emotionTitleLabel.isHidden = false
            emotionDescriptionLabel.isHidden = false
            
            emotionTitleLabel.text = emotionTitle
            emotionDescriptionLabel.text = emotionDescription
            emotionTitleLabel.textColor = emotionColor
            pickEmotionButton.setImage(Constants.pickEmotionButtonActiveImage, for: .normal)
        }
    }
}

// MARK: - Button Actions

private extension EmotionPicker {
    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}

// MARK: - Metrics & Constants

private extension EmotionPicker {
    enum Metrics {
        static let layerCornerRadius: CGFloat = 40
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .emotionPicker
        static let pickEmotionTitle: String = LocalizedKey.AddNote.pickEmotionTitle
        static let pickEmotionTitleColor: UIColor = .textPrimary
        static let pickEmotionTitleFont: UIFont = UIFont(name: "VelaSans-Regular", size: 12)!
        static let emotionTitleFont: UIFont = UIFont(name: "VelaSans-Bold", size: 12)!
        static let emotionDescriptionFont: UIFont = UIFont(name: "VelaSans-Regular", size: 12)!
        static let emotionDescriptionColor: UIColor = .textPrimary
        static let pickEmotionButtonActiveImage: UIImage = UIImage(named: "PickEmotionButtonActive")!
        static let pickEmotionButtonInactiveImage: UIImage = UIImage(named: "PickEmotionButtonInactive")!
    }
}
