//
//  CommonEmotionCell.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 12.03.2025.
//

import UIKit
import SnapKit

enum GradientColor {
    case red
    case blue
    case green
    case yellow
    
    var colors: [UIColor] {
        switch self {
        case .red:
            return [UIColor(hex: "#FF5533")!, UIColor(hex: "#FF0000")!]
        case .blue:
            return [UIColor(hex: "#33DDFF")!, UIColor(hex: "#00AAFF")!]
        case .green:
            return [UIColor(hex: "#33FFBB")!, UIColor(hex: "#00FF55")!]
        case .yellow:
            return [UIColor(hex: "#FFFF33")!, UIColor(hex: "#FFAA00")!]
        }
    }
    
    var direction: CGPoint {
        return CGPoint(x: 1.0, y: 0.5)
    }
}

class CommonEmotionCell: UICollectionViewCell {
    
    private var emotionImageView = UIImageView()
    private var emotionLabel = UILabel()
    private var usageBar = UIView()
    private var usageCountLabel = UILabel()
    private var usageBarWidthConstraint: Constraint?
    private var gradientLayer: CAGradientLayer?
    
    var emotion: Emotion? {
        didSet {
            updateUsageBar()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayerFrame()
    }
    
    func configure(with emotion: Emotion) {
        self.emotion = emotion
        emotionImageView.image = emotion.image
        emotionLabel.text = emotion.name
        usageCountLabel.text = "\(emotion.usageCount)"
        applyGradient(color: emotion.gradientColor)
        updateUsageBar()
    }
    
    private func setupUI() {
        emotionImageView.contentMode = .scaleAspectFit
        emotionLabel.font = UIFont(name: "VelaSans-Regular", size: 16)
        emotionLabel.textColor = .textPrimary
        
        usageBar.layer.cornerRadius = 16
        usageBar.clipsToBounds = true
        
        usageCountLabel.font = UIFont(name: "VelaSans-Bold", size: 14)
        usageCountLabel.textColor = .textSecondary
        usageCountLabel.textAlignment = .left
        
        contentView.addSubview(emotionImageView)
        contentView.addSubview(emotionLabel)
        contentView.addSubview(usageBar)
        usageBar.addSubview(usageCountLabel)
    }
    
    private func setupConstraints() {
        emotionImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        emotionLabel.snp.makeConstraints { make in
            make.leading.equalTo(emotionImageView.snp.trailing).offset(16)
            make.width.equalTo(140)
            make.centerY.equalToSuperview()
        }
        
        usageBar.snp.makeConstraints { make in
            make.leading.equalTo(emotionLabel.snp.trailing)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            self.usageBarWidthConstraint = make.width.equalTo(0).constraint
        }
        
        usageCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateUsageBar() {
        guard let emotion = emotion else { return }
        
        let availableWidth = contentView.bounds.width - emotionLabel.frame.maxX - 16
        let maxBarWidth = max(availableWidth, 0)
        let usageRatio = CGFloat(emotion.usageCount) / CGFloat(emotion.maxUsageCount)
        let calculatedWidth = maxBarWidth * usageRatio
        
        let minBarWidth: CGFloat = 50
        let finalWidth = max(calculatedWidth, minBarWidth)
        
        usageBarWidthConstraint?.update(offset: finalWidth)
        layoutIfNeeded()
    }
    
    private func applyGradient(color: GradientColor) {
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.colors = color.colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = color.direction
        gradient.frame = usageBar.bounds
        gradient.cornerRadius = usageBar.layer.cornerRadius
        
        usageBar.layer.insertSublayer(gradient, at: 0)
        self.gradientLayer = gradient
    }
    
    private func updateGradientLayerFrame() {
        gradientLayer?.frame = usageBar.bounds
    }
}
