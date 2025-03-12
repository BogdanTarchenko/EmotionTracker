//
//  StatisticsFourthViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 11.03.2025.
//

import UIKit
import SnapKit

class StatisticsFourthViewController: UIViewController {
    
    private var titleLabel = UILabel()
    private var emotionColumnsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
}

// MARK: - Setup UI & Constraints

private extension StatisticsFourthViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureTitleLabel()
        configureEmotionColumns()
    }
    
    func configureTitleLabel() {
        titleLabel.text = Constants.title
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = Constants.titleColor
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
    }
    
    func configureEmotionColumns() {
        emotionColumnsStackView.axis = .horizontal
        emotionColumnsStackView.alignment = .bottom
        emotionColumnsStackView.spacing = Metrics.columnSpacing
        emotionColumnsStackView.distribution = .fillEqually
        
        let columns = [
            EmotionColumn(segments: []),
            EmotionColumn(segments: [EmotionSegment(percentage: 100, color: .green)]),
            EmotionColumn(segments: [
                EmotionSegment(percentage: 50, color: .yellow),
                EmotionSegment(percentage: 50, color: .red)
            ]),
            EmotionColumn(segments: [
                EmotionSegment(percentage: 50, color: .blue),
                EmotionSegment(percentage: 30, color: .yellow),
                EmotionSegment(percentage: 20, color: .red)
            ]),
            EmotionColumn(segments: [
                EmotionSegment(percentage: 40, color: .green),
                EmotionSegment(percentage: 30, color: .blue),
                EmotionSegment(percentage: 20, color: .yellow),
                EmotionSegment(percentage: 10, color: .red)
            ])
        ]
        
        columns.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(Metrics.columnHeight)
            }
            emotionColumnsStackView.addArrangedSubview($0)
        }
    }
    
    
    func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(emotionColumnsStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Metrics.titleLabelInsets)
        }
        
        emotionColumnsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metrics.titleToColumnsSpacing)
            make.leading.trailing.equalToSuperview().inset(Metrics.titleLabelInsets)
            make.height.equalTo(Metrics.columnHeight)
        }
    }
}

// MARK: Metrics & Constants

private extension StatisticsFourthViewController {
    enum Metrics {
        static let titleLabelInsets: CGFloat = 24
        static let titleToColumnsSpacing: CGFloat = 16
        static let columnSpacing: CGFloat = 8
        static let columnHeight: CGFloat = 454
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
        static let title: String = LocalizedKey.Statistics.fourthVCTitle
        static let titleFont: UIFont = UIFont(name: "Gwen-Trial-Regular", size: 36)!
        static let titleColor: UIColor = .textPrimary
    }
}

