//
//  EditNoteViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import UIKit
import SnapKit

class EditNoteViewController: UIViewController {
    weak var coordinator: EditNoteCoordinator?
    
    var viewModel: EditNoteViewModel!
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var navigationBar = DefaultNavBar(title: Constants.navigationBarTitle)
    
    private lazy var emotionCardView: EmotionCardView = {
        return EmotionCardView(time: viewModel.time,
                               emotion: viewModel.emotionTitle,
                               emotionColor: EmotionColor.from(uiColor: viewModel.emotionColor)!,
                               icon: UIImage(named: "TestEmotionImg"))
    }()
    
    private var tagCollectionView = TagCollectionView()
    private var saveNoteButton = SaveNoteButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupButtonActions()
        
        DispatchQueue.main.async {
            self.tagCollectionView.reloadAndResize()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTagCollectionViewHeight()
        
    }
    
    private func updateTagCollectionViewHeight() {
        tagCollectionView.snp.updateConstraints { make in
            make.height.equalTo(tagCollectionView.intrinsicContentSize.height)
        }
    }
    
}

private extension EditNoteViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        configureNavigationBar()
        configureScrollView()
        configureEmotionCardView()
        configureTagCollectionView()
    }
    
    func configureScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
    }
    
    func configureEmotionCardView() {
        emotionCardView.isUserInteractionEnabled = false
    }
    
    func configureTagCollectionView() {
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tagCollectionView.selectedTags = viewModel.selectedTags
        tagCollectionView.onTagSelected = { [weak self] tag in
            self?.viewModel.toggleTag(tag)
        }
    }
    
    func setupConstraints() {
        view.addSubview(scrollView)
        view.addSubview(navigationBar)
        view.addSubview(saveNoteButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(emotionCardView)
        contentView.addSubview(tagCollectionView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Metrics.scrollViewTopEdgeOffset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(saveNoteButton.snp.top).offset(Metrics.scrollViewBottomEdgeOffset)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.defaultHorizontalInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        emotionCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.defaultHorizontalInset)
            make.top.equalToSuperview()
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.defaultHorizontalInset)
            make.top.equalTo(emotionCardView.snp.bottom).offset(Metrics.tagCollectionViewTopEdgeOffset)
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
        saveNoteButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.defaultHorizontalInset)
            make.height.equalTo(Metrics.saveNoteButtonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

private extension EditNoteViewController {
    func setupButtonActions() {
        navigationBar.onButtonTapped = { [weak self] in
            self?.coordinator?.handleBackButtonTapped()
        }
        
        saveNoteButton.onButtonTapped = { [weak self] in
            self?.coordinator?.handleSaveButtonTapped()
        }
    }
}

// MARK: - Metrics & Constants

private extension EditNoteViewController {
    enum Metrics {
        static let defaultHorizontalInset: CGFloat = 24
        static let emotionCardViewTopEdgeOffset: CGFloat = 32
        static let tagCollectionViewTopEdgeOffset: CGFloat = 24
        static let saveNoteButtonTopEdgeOffset: CGFloat = 80
        static let saveNoteButtonHeight: CGFloat = 56
        static let scrollViewBottomEdgeOffset: CGFloat = -12
        static let scrollViewTopEdgeOffset: CGFloat = 60
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
        static let navigationBarTitle: String = LocalizedKey.EditNote.navigationBarTitle
    }
}
