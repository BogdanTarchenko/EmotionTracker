//
//  EmotionCardView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 24.02.2025.
//

import UIKit

class EmotionCardView: UIView {
    
    private let timeLabel = UILabel()
    private let feelingLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.feelingLabelText
        label.textColor = Constants.feelingLabelTextColor
        label.font = Constants.feelingLabelFont
        return label
    }()
    private let emotionLabel = UILabel()
    private let iconView = UIImageView()
    
    init(time: String, emotion: String, emotionColor: EmotionColor, icon: UIImage?) {
        super.init(frame: .zero)
        setupView(time: time, emotion: emotion, emotionColor: emotionColor, icon: icon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(time: String, emotion: String, emotionColor: EmotionColor, icon: UIImage?) {
        backgroundColor = .buttonSecondary
        applyGradientOverlay(colors: emotionColor.gradientColors)
        self.layer.cornerRadius = Metrics.layerCornerRadius
        self.clipsToBounds = true
        
        timeLabel.text = time
        timeLabel.textColor = Constants.timeLabelTextColor
        timeLabel.font = Constants.timeLabelFont
        
        emotionLabel.text = emotion
        emotionLabel.textColor = emotionColor.textColor
        emotionLabel.font = Constants.emotionLabelFont
        
        iconView.image = icon
        iconView.contentMode = .scaleAspectFit
        
        addSubview(timeLabel)
        addSubview(feelingLabel)
        addSubview(emotionLabel)
        addSubview(iconView)
        
        timeLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(Metrics.timeLabelInsets)
        }
        
        feelingLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel).offset(Metrics.feelingLabelTopEdgeOffset)
            make.leading.equalToSuperview().inset(Metrics.feelingLabelLeadingEdgeOffset)
        }
        
        emotionLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(Metrics.emotionLabelInsets)
            make.top.equalTo(feelingLabel.snp.bottom)
        }
        
        iconView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(Metrics.iconViewInsets)
            make.width.height.equalTo(Metrics.iconViewSize)
        }
    }
    
    private func applyGradientOverlay(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 4, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }
}

// MARK: - Metrics & Constants

private extension EmotionCardView {
    enum Metrics {
        static let layerCornerRadius: CGFloat = 16
        static let timeLabelInsets: CGFloat = 16
        static let feelingLabelTopEdgeOffset: CGFloat = 48
        static let feelingLabelLeadingEdgeOffset: CGFloat = 16
        static let emotionLabelInsets: CGFloat = 16
        static let iconViewInsets: CGFloat = 16
        static let iconViewSize: CGFloat = 60
    }
    
    enum Constants {
        static let feelingLabelFont: UIFont = UIFont(name: "VelaSans-Regular", size: 20)!
        static let feelingLabelText: String = LocalizedKey.EmotionCardView.feelingLabelText
        static let feelingLabelTextColor: UIColor = .textPrimary
        static let timeLabelFont: UIFont = UIFont(name: "VelaSans-Regular", size: 14)!
        static let timeLabelTextColor: UIColor = .textPrimary
        static let emotionLabelFont: UIFont = UIFont(name: "Gwen-Trial-Bold", size: 28)!
    }
}
