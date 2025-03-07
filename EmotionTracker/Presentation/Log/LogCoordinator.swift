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
    
    private weak var logViewController: LogViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let logViewController = LogViewController()
        logViewController.coordinator = self
        self.logViewController = logViewController
        navigationController.setViewControllers([logViewController], animated: true)
    }
    
    func handleEmotionCardTapped(with emotionData: (title: String, color: UIColor, time: String)) {
        showEditNote(with: emotionData)
    }
    
    func handleAddNoteButtonTapped() {
        showAddNote()
    }
    
    func handleSaveNewEmotion(title: String, color: UIColor) {
        if let emotionColor = EmotionColor.from(uiColor: color) {
            logViewController?.addNewEmotion(title: title, emotionColor: emotionColor)
        }
    }
    
    private func showEditNote(with emotionData: (title: String, color: UIColor, time: String)) {
        let editNoteCoordinator = EditNoteCoordinator(navigationController: navigationController)
        editNoteCoordinator.parentCoordinator = self
        childCoordinators.append(editNoteCoordinator)
        editNoteCoordinator.start(with: emotionData)
    }
    
    private func showAddNote() {
        let addNoteCoordinator = AddNoteCoordinator(navigationController: navigationController)
        addNoteCoordinator.parentCoordinator = self
        childCoordinators.append(addNoteCoordinator)
        addNoteCoordinator.start()
    }
}
