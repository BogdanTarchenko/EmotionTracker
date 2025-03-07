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
    
    private var viewModel: EditNoteViewModel!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let editNoteViewController = EditNoteViewController()
        editNoteViewController.coordinator = self
        navigationController.pushViewController(editNoteViewController, animated: true)
    }
    
    func start(with selectedEmotion: (title: String, color: UIColor)) {
        viewModel = EditNoteViewModel(emotionTitle: selectedEmotion.title, emotionColor: selectedEmotion.color)
        let editNoteViewController = EditNoteViewController()
        editNoteViewController.viewModel = viewModel
        editNoteViewController.coordinator = self
        navigationController.pushViewController(editNoteViewController, animated: true)
    }
    
    func start(with emotionData: (title: String, color: UIColor, time: String)) {
        viewModel = EditNoteViewModel(
            emotionTitle: emotionData.title,
            emotionColor: emotionData.color,
            time: emotionData.time
        )
        let editNoteViewController = EditNoteViewController()
        editNoteViewController.viewModel = viewModel
        editNoteViewController.coordinator = self
        navigationController.pushViewController(editNoteViewController, animated: true)
    }
    
    func handleBackButtonTapped() {
        if let addNoteCoordinator = parentCoordinator as? AddNoteCoordinator {
            addNoteCoordinator.finish()
            navigationController.popViewController(animated: true)
        } else {
            self.finish()
            navigationController.popViewController(animated: true)
        }
    }
    
    func handleSaveButtonTapped() {
        if let addNoteCoordinator = parentCoordinator as? AddNoteCoordinator {
            if let logCoordinator = addNoteCoordinator.parentCoordinator as? LogCoordinator {
                if let emotionColor = EmotionColor.from(uiColor: viewModel.emotionColor) {
                    logCoordinator.handleSaveNewEmotion(
                        title: viewModel.emotionTitle,
                        color: viewModel.emotionColor
                    )
                }
            }
            addNoteCoordinator.finish()
        }
        
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
        navigationController.popToRootViewController(animated: true)
    }
}
