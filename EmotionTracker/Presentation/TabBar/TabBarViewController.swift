//
//  TabBarViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 24.02.2025.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewControllers()
    }
    
    private func setupUI() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tabBar
        appearance.stackedLayoutAppearance.selected.iconColor = Constants.selectedTabColor
        appearance.stackedLayoutAppearance.normal.iconColor = Constants.inactiveTabColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: Constants.selectedTabColor]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: Constants.inactiveTabColor]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupViewControllers() {
        let logViewController = LogViewController()
        let statisticsViewController = StatisticsViewController()
        let settingsViewController = SettingsViewController()
        
        logViewController.tabBarItem = UITabBarItem(title: Constants.logTabBarItemTitle, image: Constants.logTabBarItemIcon, tag: 0)
        statisticsViewController.tabBarItem = UITabBarItem(title: Constants.statisticsTabBarItemTitle, image: Constants.statisticsTabBarItemIcon, tag: 1)
        settingsViewController.tabBarItem = UITabBarItem(title: Constants.settingsTabBarItemTitle, image: Constants.settingsTabBarItemIcon, tag: 2)
        
        let viewControllers = [logViewController, statisticsViewController, settingsViewController]
        self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
    }
}

private extension TabBarViewController {
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
