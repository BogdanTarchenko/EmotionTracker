//
//  EmotionCardCell.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 24.02.2025.
//

import UIKit

class EmotionCardCell: UICollectionViewCell {
    static let reuseIdentifier = "EmotionCardCell"
    
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
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.sublayers?.first?.removeFromSuperlayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }
}

private extension EmotionCardCell {
    func setupUI() {
        self.layer.cornerRadius = Metrics.layerCornerRadius
        backgroundColor = .buttonSecondary
        self.clipsToBounds = true
        
        configureTimeLabel()
        configureEmotionLabel()
        configureImageView()
    }
    
    func configureTimeLabel() {
        timeLabel.textColor = Constants.timeLabelTextColor
        timeLabel.font = Constants.timeLabelFont
    }
    
    func configureEmotionLabel() {
        emotionLabel.font = Constants.emotionLabelFont
        emotionLabel.adjustsFontSizeToFitWidth = true
        emotionLabel.minimumScaleFactor = 0.8
        emotionLabel.numberOfLines = 1
    }
    
    func configureImageView() {
        iconView.contentMode = .scaleAspectFit
    }
    
    func setupConstraints() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(feelingLabel)
        contentView.addSubview(emotionLabel)
        contentView.addSubview(iconView)
        
        timeLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(Metrics.timeLabelInsets)
        }
        
        feelingLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(Metrics.feelingLabelTopEdgeOffset)
            make.leading.equalToSuperview().inset(Metrics.feelingLabelLeadingEdgeOffset)
        }
        
        emotionLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(Metrics.emotionLabelInsets)
            make.trailing.equalTo(iconView.snp.leading).offset(-Metrics.emotionLabelInsets)
            make.top.equalTo(feelingLabel.snp.bottom)
        }
        
        iconView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(Metrics.iconViewInsets)
            make.width.height.equalTo(Metrics.iconViewSize)
        }
    }
}

// MARK: - Apply Gradient Overlay

private extension EmotionCardCell {
    func applyGradientOverlay(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 4, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - Setup Gesture

private extension EmotionCardCell {
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
}

// MARK: - Button Actions

private extension EmotionCardCell {
    @objc private func handleTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.7
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.alpha = 1.0
            }
        })
        
        onTap?()
    }
}

// MARK: - Public methods

extension EmotionCardCell {
    func configure(time: String, emotion: String, emotionColor: EmotionColor, icon: UIImage?) {
        applyGradientOverlay(colors: emotionColor.gradientColors)
        
        timeLabel.text = time
        timeLabel.textColor = Constants.timeLabelTextColor
        
        emotionLabel.text = emotion.lowercased()
        emotionLabel.textColor = emotionColor.textColor
        
        iconView.image = icon
    }
}

// MARK: - Metrics & Constants

private extension EmotionCardCell {
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
