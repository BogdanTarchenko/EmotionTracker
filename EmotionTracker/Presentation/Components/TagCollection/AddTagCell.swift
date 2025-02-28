//
//  AddTagButtonView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit

class AddTagCell: UICollectionViewCell {
    
    private var imageView = UIImageView()
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AddTagCell {
    func setupUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Metrics.layerCornerRadius
        isUserInteractionEnabled = true
        configureImageView()
    }
    
    func configureImageView() {
        imageView.image = Constants.image
        imageView.tintColor = Constants.imageColor
    }
    
    func setupConstraints() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(Metrics.imageSize)
            make.leading.trailing.top.bottom.equalToSuperview().inset(Metrics.imageInset)
        }
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
}

private extension AddTagCell {
    @objc private func handleTap() {
        onTap?()
    }
}

private extension AddTagCell {
    enum Metrics {
        static let imageSize: CGFloat = 20
        static let layerCornerRadius: CGFloat = 18
        static let imageInset: CGFloat = 8
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .buttonSecondary
        static let image: UIImage = UIImage(named: "AddTagImg")!
        static let imageColor: UIColor = .textPrimary
    }
}
