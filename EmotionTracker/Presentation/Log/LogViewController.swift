//
//  LogViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 22.02.2025.
//

import UIKit
import SnapKit

final class LogViewController: UIViewController {
    weak var coordinator: LogCoordinator?
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var logNavBar = LogNavBar()
    private var logTitleLabel = UILabel()
    private var activityRingView = UIView()
    private var activityRing: ActivityRingView?
    private var addNoteButton = AddNoteButton()
    
    private var viewModel = LogViewModel()
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupButtonActions()
        reloadCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        viewModel.checkAndUpdateStreak()
        updateNavBarStats()
        updateActivityRing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func addNewEmotion(title: String, emotionColor: EmotionColor, selectedTags: Set<String>, tagsBySection: [[(tag: String, index: Int)]] = [[], [], []], selectedSectionTags: Set<EditNoteViewModel.SectionTag> = []) {
        viewModel.addNewEmotionCard(
            emotion: title, 
            emotionColor: emotionColor, 
            selectedTags: selectedTags,
            tagsBySection: tagsBySection,
            selectedSectionTags: selectedSectionTags
        )
        reloadCollectionView()
        updateNavBarStats()
        updateActivityRing()
    }
    
    func updateActivityRing() {
        let hasTodayRecords = viewModel.hasTodayRecords()
        let progress = viewModel.getRingProgress()
        
        if hasTodayRecords { 
            let emotionSegments = viewModel.getTodayEmotionsForRing()
            activityRing?.ring = ActivityRing(
                color: .ringEmpty,
                gradientColor: .ringDefault,
                progress: progress,
                emotionSegments: emotionSegments,
                isEmpty: false
            )
        } else {
            activityRing?.ring = ActivityRing(
                color: .ringEmpty,
                gradientColor: .ringDefault,
                progress: 0.5,
                emotionSegments: [],
                isEmpty: true
            )
        }
    }
    
    func updateEmotion(index: Int, title: String, emotionColor: EmotionColor, selectedTags: Set<String>, tagsBySection: [[(tag: String, index: Int)]] = [[], [], []], selectedSectionTags: Set<EditNoteViewModel.SectionTag> = []) {
        viewModel.updateEmotionCard(
            at: index,
            title: title,
            color: emotionColor,
            selectedTags: selectedTags,
            tagsBySection: tagsBySection,
            selectedSectionTags: selectedSectionTags
        )
        reloadCollectionView()
        updateNavBarStats()
    }
}

// MARK: - Setup UI & Constraints

private extension LogViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureNavigationBar()
        configureScrollView()
        configureLogNavBar()
        configureLogTitleLabel()
        configureActivityRing()
        configureCollectionView()
    }
    
    func configureScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
    }
    
    func configureLogNavBar() {
        logNavBar.configure(with: LogNavBar.ViewModel(
            totalLogs: viewModel.getTodayRecordsCount(),
            dailyGoal: viewModel.dailyGoal,
            streakDays: viewModel.getCurrentStreak()
        ))
        
        logNavBar.onDailyGoalTap = { [weak self] in
            self?.showGoalPicker()
        }
    }
    
    func configureLogTitleLabel() {
        logTitleLabel.text = Constants.logTitleLabelText
        logTitleLabel.textColor = Constants.logTitleLabelTextColor
        logTitleLabel.font = Constants.logTitleLabelFont
        logTitleLabel.numberOfLines = Metrics.logTitleLabelNumberOfLines
    }
    
    func configureActivityRing() {
        let frame = activityRingView.bounds
        
        let hasTodayRecords = viewModel.hasTodayRecords()
        let progress = viewModel.getRingProgress()
        
        if hasTodayRecords {
            let emotionSegments = viewModel.getTodayEmotionsForRing()
            activityRing = ActivityRingView(
                frame: frame, 
                ring: ActivityRing(
                    color: .ringEmpty, 
                    gradientColor: .ringDefault, 
                    progress: progress,
                    emotionSegments: emotionSegments,
                    isEmpty: false
                )
            )
        } else {
            activityRing = ActivityRingView(
                frame: frame, 
                ring: ActivityRing(
                    color: .ringEmpty, 
                    gradientColor: .ringDefault, 
                    progress: 0.5,
                    emotionSegments: [],
                    isEmpty: true
                )
            )
        }
        
        activityRingView.addSubview(activityRing!)
        
        activityRing?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Metrics.collectionViewItemSpacing
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        collectionView.register(EmotionCardCell.self, forCellWithReuseIdentifier: EmotionCardCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logNavBar)
        contentView.addSubview(logTitleLabel)
        contentView.addSubview(activityRingView)
        contentView.addSubview(collectionView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        logNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.horizontalEdgesInset)
            make.top.equalToSuperview()
            make.height.equalTo(Metrics.topEdgeOffset)
        }
        
        logTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.horizontalEdgesInset)
            make.top.equalTo(logNavBar.snp.bottom).offset(Metrics.topEdgeOffset)
        }
        
        if let activityRing = activityRing {
            activityRingView.addSubview(activityRing)
            activityRing.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        activityRingView.snp.makeConstraints { make in
            make.top.equalTo(logTitleLabel.snp.bottom).offset(Metrics.topEdgeOffset)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(activityRingView.snp.width)
        }
        activityRingView.addSubview(addNoteButton)
        addNoteButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(activityRingView.snp.bottom).offset(Metrics.topEdgeOffset)
            make.leading.trailing.equalToSuperview().inset(Metrics.horizontalEdgesInset)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().inset(Metrics.bottomEdgeInset)
        }
    }
}

// MARK: - Button Actions

private extension LogViewController {
    
    @objc func handleEmotionCardTapped(at index: Int) {
        if let emotionData = viewModel.getEmotionData(at: index) {
            let data = (
                index: index,
                title: emotionData.emotion,
                color: emotionData.emotionColor.toUIColor(),
                time: emotionData.time,
                selectedTags: emotionData.selectedTags,
                tagsBySection: emotionData.tagsBySection,
                selectedSectionTags: emotionData.selectedSectionTags
            )
            coordinator?.handleEmotionCardTapped(with: data)
        }
    }
    
    @objc func handleAddNoteButtonTapped() {
        coordinator?.handleAddNoteButtonTapped()
    }
    
    func setupButtonActions() {
        addNoteButton.onButtonTapped = { [weak self] in
            self?.handleAddNoteButtonTapped()
        }
    }
    
    func showGoalPicker() {
        let alertController = UIAlertController(
            title: Constants.alertTitle,
            message: Constants.alertMessage,
            preferredStyle: .alert
        )
        
        for i in 1...10 {
            let action = UIAlertAction(title: "\(i)", style: .default) { [weak self] _ in
                self?.viewModel.dailyGoal = i
                self?.updateNavBarStats()
                self?.updateActivityRing()
            }
            
            if i == viewModel.dailyGoal {
                action.setValue(true, forKey: "checked")
            }
            
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: Constants.alertCancel, style: .cancel))
        
        present(alertController, animated: true)
    }
    
    func updateNavBarStats() {
        logNavBar.configure(with: LogNavBar.ViewModel(
            totalLogs: viewModel.getTodayRecordsCount(),
            dailyGoal: viewModel.dailyGoal,
            streakDays: viewModel.getCurrentStreak()
        ))
    }
}

// MARK: - Collection View Height Update

private extension LogViewController {
    func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
        
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight)
        }
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.updateCollectionViewHeight()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if !self.viewModel.emotionSections.isEmpty && 
                !self.viewModel.emotionSections[0].cards.isEmpty {
                let firstIndexPath = IndexPath(item: 0, section: 0)
                self.collectionView.scrollToItem(at: firstIndexPath, at: .top, animated: true)
            }
        })
    }
}

// MARK: - UICollectionViewDataSource

extension LogViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.emotionSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.emotionSections[section].cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCardCell.reuseIdentifier, for: indexPath) as? EmotionCardCell else {
            return UICollectionViewCell()
        }
        
        let cardInfo = viewModel.emotionSections[indexPath.section].cards[indexPath.item]
        cell.configure(time: cardInfo.time, emotion: cardInfo.emotion, emotionColor: cardInfo.emotionColor, icon: cardInfo.icon)
        
        cell.onTap = { [weak self] in
            let globalIndex = self?.getGlobalIndexFromIndexPath(indexPath) ?? 0
            self?.handleEmotionCardTapped(at: globalIndex)
        }
        return cell
    }
    
    func getGlobalIndexFromIndexPath(_ indexPath: IndexPath) -> Int {
        var globalIndex = 0
        
        for section in 0..<indexPath.section {
            globalIndex += viewModel.emotionSections[section].cards.count
        }
        
        globalIndex += indexPath.item
        return globalIndex
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: Metrics.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
}

// MARK: - Metrics & Constants

private extension LogViewController {
    enum Metrics {
        static let logTitleLabelNumberOfLines: Int = 2
        static let cardStackViewSpacing: CGFloat = 8
        static let horizontalEdgesInset: CGFloat = 24
        static let topEdgeOffset: CGFloat = 32
        static let bottomEdgeInset: CGFloat = 32
        static let collectionViewItemSpacing: CGFloat = 8
        static let cellHeight: CGFloat = 158
    }
    
    enum Constants {
        static let logTitleLabelText: String = LocalizedKey.Log.logTitle
        static let logTitleLabelTextColor: UIColor = .textPrimary
        static let logTitleLabelFont: UIFont = UIFont(name: "Gwen-Trial-Regular", size: 36)!
        static let backgroundColor: UIColor = .background
        static let alertTitle: String = LocalizedKey.Log.alertTitle
        static let alertMessage: String = LocalizedKey.Log.alertMessage
        static let alertCancel: String = LocalizedKey.Log.alertCancel
    }
}
