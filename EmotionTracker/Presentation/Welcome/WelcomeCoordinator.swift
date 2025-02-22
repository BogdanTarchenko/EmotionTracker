//
//  WelcomeCoordinator.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 22.02.2025.
//

import UIKit

final class WelcomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let welcomeViewController = WelcomeViewController()
        welcomeViewController.coordinator = self
        navigationController.setViewControllers([welcomeViewController], animated: true)
    }
    
    func handleAppleIDAuthentication() {
        showLogScreen()
    }
    
    private func showLogScreen() {
        let mainCoordinator = LogCoordinator(navigationController: navigationController)
        mainCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinators.append(mainCoordinator)
        finish()
        mainCoordinator.start()
    }
}
