//
//  LogCoordinator.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 22.02.2025.
//

import UIKit

final class LogCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let logViewController = LogViewController()
        logViewController.coordinator = self
        navigationController.setViewControllers([logViewController], animated: true)
    }
    
    func handleEmotionCardTapped() {
        showEditNote()
    }
    
    private func showEditNote() {
        let editNoteCoordinator = EditNoteCoordinator(navigationController: navigationController)
        editNoteCoordinator.parentCoordinator = parentCoordinator
        childCoordinators.append(editNoteCoordinator)
        editNoteCoordinator.start()
    }
}
