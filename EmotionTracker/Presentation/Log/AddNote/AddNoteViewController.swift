//
//  AddNoteViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit
import SnapKit

class AddNoteViewController: UIViewController {
    weak var coordinator: AddNoteCoordinator?
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var navigationBar = DefaultNavBar(title: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupButtonActions()
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
}

private extension AddNoteViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        configureNavigationBar()
        configureScrollView()
    }
    
    func configureScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
    }
    
    func setupConstraints() {
        view.addSubview(scrollView)
        view.addSubview(navigationBar)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Metrics.scrollViewTopEdgeOffset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.defaultHorizontalInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

private extension AddNoteViewController {
    func setupButtonActions() {
        navigationBar.onButtonTapped = {
            self.coordinator?.handleBackButtonTapped()
        }
    }
}

// MARK: - Metrics & Constants

private extension AddNoteViewController {
    enum Metrics {
        static let defaultHorizontalInset: CGFloat = 24
        static let scrollViewTopEdgeOffset: CGFloat = 60
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
    }
}
