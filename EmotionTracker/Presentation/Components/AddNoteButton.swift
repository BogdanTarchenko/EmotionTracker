//
//  AddNoteButton.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 24.02.2025.
//

import UIKit
import SnapKit

class AddNoteButton: UIView {
    
    var onButtonTapped: (() -> Void)?
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(Constants.buttonImage, for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = Constants.labelText
        label.textColor = .textPrimary
        label.font = Constants.labelFont
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(button)
        addSubview(label)
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(Metrics.buttonSize)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(Metrics.labelTopEdgeOffset)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}

// MARK: - Button Actions

private extension AddNoteButton {
    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}

// MARK: - Metrics & Constants

private extension AddNoteButton {
    enum Metrics {
        static let buttonSize: CGFloat = 64
        static let labelTopEdgeOffset: CGFloat = 8
    }
    
    enum Constants {
        static let buttonImage: UIImage = UIImage(named: "AddNoteImg")!
        static let labelText: String = LocalizedKey.AddNoteButton.title
        static let labelFont: UIFont = UIFont(name: "VelaSans-Medium", size: 16)!
    }
}
