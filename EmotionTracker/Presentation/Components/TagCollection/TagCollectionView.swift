//
//  TagCollectionView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit

class TagCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let sections = Constants.sections
    private var viewModel: EditNoteViewModel?
    
    var selectedTags: Set<String> = []
    var onTagSelected: ((String, Int) -> Void)?
    var onTagAdded: ((String, Int) -> Bool)?
    
    private var editingIndexPath: IndexPath?
    
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
    
    func configure(with viewModel: EditNoteViewModel) {
        self.viewModel = viewModel
        reloadData()
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.getTagsForSection(section).count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tagsInSection = viewModel?.getTagsForSection(indexPath.section) ?? []
        
        if indexPath.row == tagsInSection.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddTagCell", for: indexPath) as! AddTagCell
            cell.onTap = {
                cell.startEditing()
            }
            cell.onTagAdded = { [weak self] newTag in
                self?.handleNewTag(newTag, inSection: indexPath.section)
            }
            return cell
        } else {
            let tag = tagsInSection[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
            
            let isSelected = viewModel?.isTagSelected(tag, section: indexPath.section) ?? false
            cell.configure(with: tag, isSelected: isSelected)
            
            cell.onTap = { [weak self] in
                guard let self = self, let viewModel = self.viewModel else { return }
                
                self.onTagSelected?(tag, indexPath.section)
                
                cell.configure(with: tag, isSelected: viewModel.isTagSelected(tag, section: indexPath.section))
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
    
    private func handleNewTag(_ tag: String, inSection section: Int) {
        if let success = onTagAdded?(tag, section), success {
            UIView.animate(withDuration: 0.3) {
                self.reloadSection(section)
            }
        } else {
            showDuplicateTagAlert()
        }
    }
    
    private func showDuplicateTagAlert() {
        guard let viewController = self.findViewController() else { return }
        
        let alert = UIAlertController(
            title: Constants.alertTitle,
            message: Constants.alertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: Constants.okButton, style: .default))
        viewController.present(alert, animated: true)
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    private func reloadSection(_ section: Int) {
        reloadSections(IndexSet(integer: section))
        invalidateIntrinsicContentSize()
        superview?.layoutIfNeeded()
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
        static let sections: [String] = ["Чем вы занимались?", "С кем вы были?", "Где вы были?"]
        static let alertTitle = LocalizedKey.EditNote.duplicatedTagsAlertTitle
        static let alertMessage = LocalizedKey.EditNote.duplicatedTagsAlertMessage
        static let okButton = "OK"
    }
}
