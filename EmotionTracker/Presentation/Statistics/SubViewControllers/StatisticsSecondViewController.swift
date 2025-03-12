//
//  StatisticsSecondViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 11.03.2025.
//

import UIKit
import SnapKit

class StatisticsSecondViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let collectionView: UICollectionView
    
    private let weekData: [(day: String, date: String, emotions: [String], images: [UIImage])] = [
        ("Понедельник", "6 мар", ["Спокойствие", "Продуктивность", "Счастье"], [UIImage(named: "TestEmotionBlueImg")!, UIImage(named: "TestEmotionBlueImg")!, UIImage(named: "TestEmotionBlueImg")!]),
        ("Вторник", "7 мар", ["Расслабленность", "Энергия"], [UIImage(named: "TestEmotionBlueImg")!, UIImage(named: "TestEmotionBlueImg")!]),
        ("Среда", "8 мар", ["Радость", "Фокус"], [UIImage(named: "TestEmotionBlueImg")!, UIImage(named: "TestEmotionBlueImg")!]),
        ("Четверг", "9 мар", ["Спокойствие", "Тревога"], [UIImage(named: "TestEmotionBlueImg")!, UIImage(named: "TestEmotionBlueImg")!]),
        ("Пятница", "10 мар", ["Эйфория", "Продуктивность", "Счастье", "Радость"], [UIImage(named: "TestEmotionBlueImg")!, UIImage(named: "TestEmotionBlueImg")!,UIImage(named: "TestEmotionBlueImg")!, UIImage(named: "TestEmotionBlueImg")!]),
        ("Суббота", "11 мар", ["Лень", "Расслабленность"], [UIImage(named: "TestEmotionBlueImg")!, UIImage(named: "TestEmotionBlueImg")!]),
        ("Воскресенье", "12 мар", ["Счастье", "Удовлетворение"], [UIImage(named: "TestEmotionBlueImg")!, UIImage(named: "TestEmotionBlueImg")!])
    ]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
}

// MARK: - Setup UI & Constraints

private extension StatisticsSecondViewController {
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
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(WeekEmotionCell.self, forCellWithReuseIdentifier: "WeekEmotionCell")
    }
    
    func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Metrics.titleLabelInsets)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalToSuperview().inset(24)
            make.height.equalTo(400)
        }
    }
}

// MARK: - UICollectionView Delegate & DataSource

extension StatisticsSecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekEmotionCell", for: indexPath) as? WeekEmotionCell else {
            return UICollectionViewCell()
        }
        
        let data = weekData[indexPath.row]
        cell.configure(weekDay: data.day, date: data.date, emotions: data.emotions, emotionImages: data.images)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let baseHeight: CGFloat = 72
        let extraHeight: CGFloat = 40
        let imagesPerRow = 3
        
        let imagesCount = weekData[indexPath.row].images.count
        let emotionsCount = weekData[indexPath.row].emotions.count
        let numberOfRows = max(Int(ceil(Double(imagesCount) / Double(imagesPerRow))), emotionsCount / 2)
        
        let totalHeight = baseHeight + CGFloat(max(0, numberOfRows - 1)) * extraHeight
        return CGSize(width: UIScreen.main.bounds.width - 32, height: totalHeight)
    }
}

// MARK: - Metrics & Constants

private extension StatisticsSecondViewController {
    enum Metrics {
        static let titleLabelInsets: CGFloat = 24
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
        static let title: String = LocalizedKey.Statistics.secondVCTitle
        static let titleFont: UIFont = UIFont(name: "Gwen-Trial-Regular", size: 36)!
        static let titleColor: UIColor = .textPrimary
    }
}
