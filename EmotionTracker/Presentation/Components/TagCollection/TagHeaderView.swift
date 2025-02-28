//
//  TagHeaderView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit
import SnapKit

class TagHeaderView: UICollectionReusableView {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

private extension TagHeaderView {
    func setupUI() {
        titleLabel.textColor = Constants.titleColor
        titleLabel.font = Constants.titleFont
        titleLabel.textAlignment = .left
    }
    
    func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

private extension TagHeaderView {
    enum Constants {
        static let titleColor: UIColor = .textPrimary
        static let titleFont: UIFont = UIFont(name: "VelaSans-Medium", size: 16)!
    }
}
