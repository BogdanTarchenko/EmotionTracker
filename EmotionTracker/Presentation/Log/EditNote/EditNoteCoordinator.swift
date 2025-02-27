//
//  EditNoteCoordinator.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import UIKit

final class EditNoteCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let editNoteViewController = EditNoteViewController()
        editNoteViewController.coordinator = self
        navigationController.pushViewController(editNoteViewController, animated: true)
    }
    
    func handleBackButtonTapped() {
        navigationController.popViewController(animated: true)
    }
}
