//
//  AddNoteCoordinator.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit

final class AddNoteCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.coordinator = self
        navigationController.pushViewController(addNoteViewController, animated: true)
    }
    
    func handleBackButtonTapped() {
        self.finish()
        navigationController.popViewController(animated: true)
    }
    
    func showEditNote(selectedEmotion: (title: String, color: UIColor)) {
        let editNoteCoordinator = EditNoteCoordinator(navigationController: navigationController)
        editNoteCoordinator.parentCoordinator = self
        childCoordinators.append(editNoteCoordinator)
        editNoteCoordinator.start(with: selectedEmotion)
    }
}
