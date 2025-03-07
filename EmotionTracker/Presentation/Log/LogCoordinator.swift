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
        navigationController.setViewControllers([logViewController], animated: false)
    }
    
    func handleEmotionCardTapped(with emotionData: (index: Int, title: String, color: UIColor, time: String, selectedTags: Set<String>, tagsBySection: [[(tag: String, index: Int)]], selectedSectionTags: Set<EditNoteViewModel.SectionTag>)) {
        showEditNote(with: emotionData)
    }
    
    func handleAddNoteButtonTapped() {
        showAddNote()
    }
    
    func handleSaveNewEmotion(title: String, color: UIColor, selectedTags: Set<String>, tagsBySection: [[(tag: String, index: Int)]] = [[], [], []], selectedSectionTags: Set<EditNoteViewModel.SectionTag> = []) {
        if let emotionColor = EmotionColor.from(uiColor: color) {
            logViewController?.addNewEmotion(
                title: title, 
                emotionColor: emotionColor, 
                selectedTags: selectedTags,
                tagsBySection: tagsBySection,
                selectedSectionTags: selectedSectionTags
            )
        }
    }
    
    func handleUpdateEmotion(index: Int, title: String, color: UIColor, selectedTags: Set<String>, tagsBySection: [[(tag: String, index: Int)]], selectedSectionTags: Set<EditNoteViewModel.SectionTag> = []) {
        if let emotionColor = EmotionColor.from(uiColor: color) {
            logViewController?.updateEmotion(
                index: index,
                title: title,
                emotionColor: emotionColor,
                selectedTags: selectedTags,
                tagsBySection: tagsBySection,
                selectedSectionTags: selectedSectionTags
            )
        }
    }
    
    private func showEditNote(with emotionData: (index: Int, title: String, color: UIColor, time: String, selectedTags: Set<String>, tagsBySection: [[(tag: String, index: Int)]], selectedSectionTags: Set<EditNoteViewModel.SectionTag>)) {
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
