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
        let emotionColor = EmotionColor.from(uiColor: viewModel.emotionColor)!
        return EmotionCardView(time: viewModel.time,
                               emotion: viewModel.emotionTitle,
                               emotionColor: emotionColor,
                               icon: viewModel.getEmotionIcon(for: viewModel.emotionColor))
    }()
    
    private var tagCollectionView = TagCollectionView()
    private var saveNoteButton = SaveNoteButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupButtonActions()
        setupKeyboardHandling()
        
        DispatchQueue.main.async {
            self.tagCollectionView.reloadAndResize()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
        
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = false
        
        removeKeyboardObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTagCollectionViewHeight()
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
        tagCollectionView.configure(with: viewModel)
        tagCollectionView.onTagSelected = { [weak self] tag, section in
            guard let self = self else { return }
            
            self.viewModel.toggleTag(tag, section: section)
        }
        tagCollectionView.onTagAdded = { [weak self] tag, section in
            guard let self = self else { return false }
            return self.viewModel.addTag(tag, section: section)
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
    func updateTagCollectionViewHeight() {
        tagCollectionView.snp.updateConstraints { make in
            make.height.equalTo(tagCollectionView.intrinsicContentSize.height)
        }
    }
    
    func updateEmotionIcon() {
        let emotionIcon = viewModel.getEmotionIcon(for: viewModel.emotionColor)
        emotionCardView.updateIcon(image: emotionIcon)
    }
    
    func findActiveTextField() -> UIView? {
        return view.findSubview(ofType: UITextField.self, where: { $0.isFirstResponder }) ??
        view.findSubview(ofType: UITextView.self, where: { $0.isFirstResponder })
    }
}

// MARK: - Button Actions

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

// MARK: - Keyboard Handling

private extension EditNoteViewController {
    func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let bottomInset = keyboardHeight + Metrics.keyboardInsets
            
            scrollView.contentInset.bottom = bottomInset
            var verticalInsets = scrollView.verticalScrollIndicatorInsets
            verticalInsets.bottom = bottomInset
            scrollView.verticalScrollIndicatorInsets = verticalInsets
            
            if let activeTextField = findActiveTextField() {
                let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: scrollView)
                scrollView.scrollRectToVisible(textFieldFrame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        var verticalInsets = scrollView.verticalScrollIndicatorInsets
        verticalInsets.bottom = 0
        scrollView.verticalScrollIndicatorInsets = verticalInsets
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
        static let keyboardInsets: CGFloat = 20
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
        static let navigationBarTitle: String = LocalizedKey.EditNote.navigationBarTitle
    }
}
