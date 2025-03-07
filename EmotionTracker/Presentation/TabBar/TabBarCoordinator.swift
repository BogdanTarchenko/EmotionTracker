//
//  TabBarCoordinator.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 24.02.2025.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarController = TabBarViewController()
        
        let logCoordinator = LogCoordinator(navigationController: UINavigationController())
        let statisticsCoordinator = StatisticsCoordinator(navigationController: UINavigationController())
        let settingsCoordinator = SettingsCoordinator(navigationController: UINavigationController())
        
        logCoordinator.start()
        statisticsCoordinator.start()
        settingsCoordinator.start()
        
        childCoordinators.append(logCoordinator)
        childCoordinators.append(statisticsCoordinator)
        childCoordinators.append(settingsCoordinator)
        
        tabBarController.viewControllers = [
            logCoordinator.navigationController,
            statisticsCoordinator.navigationController,
            settingsCoordinator.navigationController
        ]
        
        setupTabBarItems(for: tabBarController, logCoordinator: logCoordinator, statisticsCoordinator: statisticsCoordinator, settingsCoordinator: settingsCoordinator)
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func setupTabBarItems(for tabBarController: TabBarViewController, logCoordinator: LogCoordinator, statisticsCoordinator: StatisticsCoordinator, settingsCoordinator: SettingsCoordinator) {
        let logViewController = logCoordinator.navigationController.topViewController as! LogViewController
        let statisticsViewController = statisticsCoordinator.navigationController.topViewController as! StatisticsViewController
        let settingsViewController = settingsCoordinator.navigationController.topViewController as! SettingsViewController
        
        logViewController.tabBarItem = UITabBarItem(title: Constants.logTabBarItemTitle, image: Constants.logTabBarItemIcon, tag: 0)
        statisticsViewController.tabBarItem = UITabBarItem(title: Constants.statisticsTabBarItemTitle, image: Constants.statisticsTabBarItemIcon, tag: 1)
        settingsViewController.tabBarItem = UITabBarItem(title: Constants.settingsTabBarItemTitle, image: Constants.settingsTabBarItemIcon, tag: 2)
    }
}

private extension TabBarCoordinator {
    enum Constants {
        static let logTabBarItemTitle: String = LocalizedKey.TabBar.logTabBarItemTitle
        static let statisticsTabBarItemTitle: String = LocalizedKey.TabBar.statisticsTabBarItemTitle
        static let settingsTabBarItemTitle: String = LocalizedKey.TabBar.settingsTabBarItemTitle
        static let logTabBarItemIcon: UIImage = UIImage(named: "logIcon")!
        static let statisticsTabBarItemIcon: UIImage = UIImage(named: "statisticsIcon")!
        static let settingsTabBarItemIcon: UIImage = UIImage(named: "settingsIcon")!
        static let selectedTabColor: UIColor = .tabBarItemActive
        static let inactiveTabColor: UIColor = .tabBarItemInactive
    }
}
