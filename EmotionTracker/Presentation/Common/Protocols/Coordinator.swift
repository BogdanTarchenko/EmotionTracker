//
//  Coordinator.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 22.02.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
    }
}
