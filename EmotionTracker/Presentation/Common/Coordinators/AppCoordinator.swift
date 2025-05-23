//
//  AppCoordinator.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 22.02.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let coreDataService: CoreDataServiceProtocol
    private let biometricService: BiometricServiceProtocol
    
    init(navigationController: UINavigationController,
         coreDataService: CoreDataServiceProtocol = CoreDataService(),
         biometricService: BiometricServiceProtocol = BiometricService()) {
        self.navigationController = navigationController
        self.coreDataService = coreDataService
        self.biometricService = biometricService
    }
    
    func start() {
        if coreDataService.isBiometricEnabled {
            showBiometricAuth()
        } else {
            showWelcome()
        }
    }
    
    private func showBiometricAuth() {
        let authVC = BiometricAuthViewController(biometricService: biometricService) { [weak self] in
            self?.showTabBar()
        }
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([authVC], animated: false)
    }
    
    private func showWelcome() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController)
        welcomeCoordinator.parentCoordinator = self
        childCoordinators.append(welcomeCoordinator)
        welcomeCoordinator.start()
    }
    
    private func showTabBar() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.parentCoordinator = self
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    func handleAppDidBecomeActive() {
        if coreDataService.isBiometricEnabled {
            showBiometricAuth()
        }
    }
}
