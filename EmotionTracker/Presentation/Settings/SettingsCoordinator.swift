//
//  SettingsCoordinator.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 26.02.2025.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingsViewController = SettingsViewController()
        settingsViewController.coordinator = self
        navigationController.setViewControllers([settingsViewController], animated: false)
    }
}
