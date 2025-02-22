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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension LogViewController {
    func setupUI() {
        view.backgroundColor = .background
    }
}

private extension LogViewController {
    enum Constants {
        static let titleFont = UIFont(name: "Gwen-Trial-Regular", size: 36)
        static let titleTextColor: UIColor = .textPrimary
    }
}
