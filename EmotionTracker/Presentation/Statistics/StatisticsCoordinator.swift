//
//  StatisticsCoordinator.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import UIKit

final class StatisticsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.coordinator = self
        navigationController.setViewControllers([statisticsViewController], animated: true)
    }
}
