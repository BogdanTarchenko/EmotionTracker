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
    
    private var navigationBar = DefaultNavBar(title: nil)
    private var emotionPicker = EmotionPicker(state: .active(emotionTitle: "Усталость", emotionDescription: "ощущение, что необходимо отдохнуть", emotionColor: .bluePrimary))

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
    }
    
    func setupConstraints() {
        view.addSubview(navigationBar)
        view.addSubview(emotionPicker)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.defaultHorizontalInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        emotionPicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.defaultHorizontalInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
    }
}
