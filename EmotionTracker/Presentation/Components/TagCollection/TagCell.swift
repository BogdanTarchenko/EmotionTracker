//
//  TagCell.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit
import SnapKit

class TagCell: UICollectionViewCell {
    
    private var label = UILabel()
    
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
    
    func configure(with text: String) {
        label.text = text
    }
}

private extension TagCell {
    func setupUI() {
        contentView.backgroundColor = Constants.tagColor
        contentView.layer.cornerRadius = Metrics.tagCornerRadius
        contentView.clipsToBounds = true
        configureLabel()
    }
    
    func configureLabel() {
        label.textColor = Constants.labelColor
        label.font = Constants.labelFont
        label.textAlignment = .center
        label.numberOfLines = 1
    }
    
    func setupConstraints() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Metrics.labelVerticalInset)
            make.leading.trailing.equalToSuperview().inset(Metrics.labelHorizontalInset)
        }
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
}

// MARK: - Button Actions

private extension TagCell {
    @objc private func handleTap() {
        let isActive = contentView.backgroundColor == Constants.tagColor
        let newColor = isActive ? Constants.activeTagColor : Constants.tagColor
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.backgroundColor = newColor
        })
        
        onTap?()
    }
    
}

private extension TagCell {
    enum Metrics {
        static let tagCornerRadius: CGFloat = 18
        static let labelVerticalInset: CGFloat = 8
        static let labelHorizontalInset: CGFloat = 16
    }
    
    enum Constants {
        static let tagColor: UIColor = .buttonSecondary
        static let activeTagColor: UIColor = .buttonActive
        static let labelColor: UIColor = .textPrimary
        static let labelFont: UIFont = UIFont(name: "VelaSans-Regular", size: 14)!
    }
}

