//
//  StatisticsThirdViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 11.03.2025.
//

import UIKit
import SnapKit

class StatisticsThirdViewController: UIViewController {
    
    private var titleLabel = UILabel()
    private var emotionsCollectionView: UICollectionView!
    private var emotions: [Emotion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadTestData()
    }
    
    func loadTestData() {
        emotions = [
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Спокойствие", usageCount: 20, maxUsageCount: 80, gradientColor: .blue),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Продуктивность", usageCount: 80, maxUsageCount: 80, gradientColor: .green),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Счастье", usageCount: 60, maxUsageCount: 80, gradientColor: .yellow),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 80, maxUsageCount: 80, gradientColor: .red),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 50, maxUsageCount: 80, gradientColor: .yellow),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 50, maxUsageCount: 80, gradientColor: .red),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 50, maxUsageCount: 80, gradientColor: .green),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 80, maxUsageCount: 80, gradientColor: .red),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 50, maxUsageCount: 80, gradientColor: .yellow),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 50, maxUsageCount: 80, gradientColor: .red),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 50, maxUsageCount: 80, gradientColor: .green),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 80, maxUsageCount: 80, gradientColor: .red),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 50, maxUsageCount: 80, gradientColor: .yellow),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 50, maxUsageCount: 80, gradientColor: .red),
            Emotion(image: UIImage(named: "TestEmotionBlueImg")!, name: "Выгорание", usageCount: 50, maxUsageCount: 80, gradientColor: .green)
        ]
        
        emotions.sort { $0.usageCount > $1.usageCount }
        
        emotionsCollectionView.reloadData()
    }
}

// MARK: - Setup UI & Constraints

private extension StatisticsThirdViewController {
    
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureTitleLabel()
        configureCollectionView()
    }
    
    func configureTitleLabel() {
        titleLabel.text = Constants.title
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = Constants.titleColor
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 48, height: 32)
        
        emotionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        emotionsCollectionView.register(CommonEmotionCell.self, forCellWithReuseIdentifier: "CommonEmotionCell")
        emotionsCollectionView.dataSource = self
        emotionsCollectionView.delegate = self
        emotionsCollectionView.backgroundColor = .clear
        
        view.addSubview(emotionsCollectionView)
    }
    
    func setupConstraints() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Metrics.titleLabelInsets)
        }
        
        emotionsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(400)
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension StatisticsThirdViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonEmotionCell", for: indexPath) as! CommonEmotionCell
        let emotion = emotions[indexPath.row]
        cell.configure(with: emotion)
        return cell
    }
}

// MARK: - Emotion Model

struct Emotion {
    let image: UIImage
    let name: String
    var usageCount: Int
    let maxUsageCount: Int
    let gradientColor: GradientColor
}

// MARK: - Metrics & Constants

private extension StatisticsThirdViewController {
    enum Metrics {
        static let titleLabelInsets: CGFloat = 24
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
        static let title: String = LocalizedKey.Statistics.thirdVCTitle
        static let titleFont: UIFont = UIFont(name: "Gwen-Trial-Regular", size: 36)!
        static let titleColor: UIColor = .textPrimary
    }
}
