//
//  HorizontalTabView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 11.03.2025.
//

import UIKit
import SnapKit

class HorizontalTabView: UIView {
    
    private var tabTitles: [String] = []
    private var selectedIndex: Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .background
        collectionView.register(TabCell.self, forCellWithReuseIdentifier: TabCell.identifier)
        return collectionView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .customSeparator
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        generateTabTitles()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HorizontalTabView {
    func generateTabTitles() {
        let calendar = Calendar.current
        let startDate = Date()
        var titles: [String] = []
        
        for i in 0..<52 {
            let endOfWeek = calendar.date(byAdding: .weekOfYear, value: -i, to: startDate)!
            let startOfWeek = calendar.date(byAdding: .day, value: -6, to: endOfWeek)!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            let startDay = formatter.string(from: startOfWeek)
            let endDay = formatter.string(from: endOfWeek)
            
            formatter.dateFormat = "MMMM"
            let fullMonth = formatter.string(from: startOfWeek)
            let month = String(fullMonth.prefix(3))
            
            titles.append("\(startDay)-\(endDay) \(month)")
        }
        
        self.tabTitles = titles
    }
    
    func setupUI() {
        addSubview(collectionView)
        addSubview(separatorView)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(1)
        }
    }
}

extension HorizontalTabView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCell.identifier, for: indexPath) as! TabCell
        let isSelected = indexPath.item == selectedIndex
        cell.configure(with: tabTitles[indexPath.item], isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 48)
    }
}

private class TabCell: UICollectionViewCell {
    static let identifier = "TabCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Constants.font
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 1.5
        view.isHidden = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-2)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.textColor = .textPrimary
        underlineView.isHidden = !isSelected
    }
}

private extension TabCell {
    enum Metrics {
        
    }
    
    enum Constants {
        static let font: UIFont = UIFont(name: "VelaSans-Regular", size: 16)!
    }
}
