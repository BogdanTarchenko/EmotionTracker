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
    
    func start(with emotion: (title: String, color: UIColor)) {
        viewModel = EditNoteViewModel(
            emotionTitle: emotion.title,
            emotionColor: emotion.color
        )
        let editNoteViewController = EditNoteViewController()
        editNoteViewController.viewModel = viewModel
        editNoteViewController.coordinator = self
        navigationController.pushViewController(editNoteViewController, animated: true)
    }
    
    func start(with emotionData: (index: Int, title: String, color: UIColor, time: String, selectedTags: Set<String>, tagsBySection: [[(tag: String, index: Int)]], selectedSectionTags: Set<EditNoteViewModel.SectionTag>)) {
        viewModel = EditNoteViewModel(
            index: emotionData.index,
            emotionTitle: emotionData.title,
            emotionColor: emotionData.color,
            time: emotionData.time,
            selectedTags: emotionData.selectedTags,
            tagsBySection: emotionData.tagsBySection,
            selectedSectionTags: emotionData.selectedSectionTags
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
                if EmotionColor.from(uiColor: viewModel.emotionColor) != nil {
                    logCoordinator.handleSaveNewEmotion(
                        title: viewModel.emotionTitle,
                        color: viewModel.emotionColor,
                        selectedTags: viewModel.selectedTags,
                        tagsBySection: viewModel.tagsBySection,
                        selectedSectionTags: viewModel.selectedSectionTags
                    )
                }
            }
            addNoteCoordinator.finish()
        } else if let logCoordinator = parentCoordinator as? LogCoordinator {
            if let index = viewModel.index {
                logCoordinator.handleUpdateEmotion(
                    index: index,
                    title: viewModel.emotionTitle,
                    color: viewModel.emotionColor,
                    selectedTags: viewModel.selectedTags,
                    tagsBySection: viewModel.tagsBySection,
                    selectedSectionTags: viewModel.selectedSectionTags
                )
            }
        }
        
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
        navigationController.popToRootViewController(animated: true)
    }
}
