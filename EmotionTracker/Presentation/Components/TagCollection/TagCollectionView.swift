//
//  TagCollectionView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit

class TagCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let sections = ["Чем вы занимались?", "С кем вы были?", "Где вы были?"]
    let items = [
        ["Приём пищи", "Встреча с друзьями", "Тренировка", "Хобби", "Отдых", "Поездка", "+"],
        ["Один", "Друзья", "Семья", "Коллеги", "Партнёр", "Питомцы", "+"],
        ["Дом", "Работа", "Школа", "Транспорт", "Улица", "+"]
    ]
    
    var selectedTags: Set<String> = []
    var onTagSelected: ((String) -> Void)?
    
    init() {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Metrics.spacing
        layout.minimumLineSpacing = Metrics.spacing
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        self.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        self.register(AddTagCell.self, forCellWithReuseIdentifier: "AddTagCell")
        self.register(TagHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TagHeaderView")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section][indexPath.row]
        
        if item == Constants.plusString {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddTagCell", for: indexPath) as! AddTagCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
            cell.configure(with: item, isSelected: selectedTags.contains(item))
            cell.onTap = { [weak self] in
                self?.onTagSelected?(item)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Metrics.sectionsInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Metrics.headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TagHeaderView", for: indexPath) as! TagHeaderView
        headerView.configure(with: sections[indexPath.section])
        return headerView
    }
    
    func reloadAndResize() {
        self.reloadData()
        DispatchQueue.main.async {
            self.collectionViewLayout.invalidateLayout()
            self.invalidateIntrinsicContentSize()
            self.superview?.layoutIfNeeded()
        }
    }
    
    func updateSelectedTags(_ tags: Set<String>) {
        selectedTags = tags
        reloadData()
    }
}

private extension TagCollectionView {
    enum Metrics {
        static let spacing: CGFloat = 4
        static let sectionsInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        static let headerHeight: CGFloat = 32
    }
    
    enum Constants {
        static let plusString: String = "+"
    }
}
