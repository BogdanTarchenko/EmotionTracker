//
//  WeekEmotionCell.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 12.03.2025.
//

import UIKit
import SnapKit

class WeekEmotionCell: UICollectionViewCell {
    
    private let weekDayLabel = UILabel()
    private let dateLabel = UILabel()
    private let labelsStackView = UIStackView()
    private let imagesStackView = UIStackView()
    
    private let dateContainerStackView = UIStackView()
    private let mainStackView = UIStackView()
    private let contentContainerStackView = UIStackView()
    
    private let separatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(weekDay: String, date: String, emotions: [String], emotionImages: [UIImage]) {
        weekDayLabel.text = weekDay
        dateLabel.text = date
        
        labelsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        imagesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for emotion in emotions {
            let label = UILabel()
            label.text = emotion
            label.textColor = .emotionLabel
            label.font = UIFont(name: "VelaSans-Regular", size: 12)
            labelsStackView.addArrangedSubview(label)
        }
        
        var rowStackView = createRowStackView()
        
        for (index, image) in emotionImages.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.snp.makeConstraints { $0.size.equalTo(40) }
            rowStackView.addArrangedSubview(imageView)
            
            if (index + 1) % 3 == 0 || index == emotionImages.count - 1 {
                imagesStackView.addArrangedSubview(rowStackView)
                rowStackView = createRowStackView()
            }
        }
    }
}

// MARK: - UI Setup

private extension WeekEmotionCell {
    func setupUI() {
        weekDayLabel.font = UIFont(name: "VelaSans-Regular", size: 12)
        weekDayLabel.textColor = .textPrimary
        
        dateLabel.font = UIFont(name: "VelaSans-Regular", size: 12)
        dateLabel.textColor = .textPrimary
        
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 0
        labelsStackView.alignment = .leading
        labelsStackView.distribution = .equalSpacing
        
        imagesStackView.axis = .vertical
        imagesStackView.spacing = 4
        imagesStackView.alignment = .trailing
        imagesStackView.distribution = .fill
        
        dateContainerStackView.axis = .vertical
        dateContainerStackView.spacing = 0
        dateContainerStackView.alignment = .leading
        dateContainerStackView.addArrangedSubview(weekDayLabel)
        dateContainerStackView.addArrangedSubview(dateLabel)
        
        contentContainerStackView.axis = .horizontal
        contentContainerStackView.alignment = .center
        contentContainerStackView.spacing = 16
        
        contentContainerStackView.addArrangedSubview(labelsStackView)
        contentContainerStackView.addArrangedSubview(imagesStackView)
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 16
        mainStackView.alignment = .center
        mainStackView.addArrangedSubview(dateContainerStackView)
        mainStackView.addArrangedSubview(contentContainerStackView)
        
        contentView.addSubview(mainStackView)
        
        separatorView.backgroundColor = .emotionSeparator
        contentView.addSubview(separatorView)
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
        contentContainerStackView.snp.makeConstraints { make in
            make.leading.equalTo(dateContainerStackView.snp.trailing).offset(16)
        }
        
        labelsStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        imagesStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
        
        dateContainerStackView.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
    }
    
    func createRowStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }
}
