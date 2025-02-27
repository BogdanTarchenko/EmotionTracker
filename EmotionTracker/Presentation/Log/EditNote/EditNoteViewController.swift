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
    
    private var navigationBar = DefaultNavBar(title: Constants.navigationBarTitle)

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

private extension EditNoteViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        configureNavigationBar()
    }
    
    func setupConstraints() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.defaultHorizontalInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

private extension EditNoteViewController {
    func setupButtonActions() {
        navigationBar.onButtonTapped = {
            self.coordinator?.handleBackButtonTapped()
        }
    }
}

// MARK: - Metrics & Constants

private extension EditNoteViewController {
    enum Metrics {
        static let defaultHorizontalInset: CGFloat = 24
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
        static let navigationBarTitle: String = LocalizedKey.EditNote.navigationBarTitle
    }
}
