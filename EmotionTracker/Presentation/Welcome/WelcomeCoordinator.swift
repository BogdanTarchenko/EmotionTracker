//
//  WelcomeCoordinator.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 22.02.2025.
//

import UIKit
import AuthenticationServices

final class WelcomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let welcomeViewController = WelcomeViewController()
        welcomeViewController.coordinator = self
        navigationController.setViewControllers([welcomeViewController], animated: false)
    }
    
    func handleAppleIDAuthentication() {
        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webViewController.view.addSubview(webView)
        
        if let url = URL(string: "https://appleid.apple.com") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
        
        navigationController.present(webViewController, animated: true)
        
        let workItem = DispatchWorkItem { [weak self] in
            webViewController.dismiss(animated: true) {
                let userID = "test.user.id"
                let email = "test@example.com"
                let identityToken = "mock.identity.token".data(using: .utf8)
                let authorizationCode = "mock.auth.code".data(using: .utf8)
                
                UserDefaults.standard.set(userID, forKey: "appleUserID")
                UserDefaults.standard.set(email, forKey: "appleUserEmail")
                
                self?.showTabBar()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: workItem)
    }
    
    private func showTabBar() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinators.append(tabBarCoordinator)
        finish()
        tabBarCoordinator.start()
    }
}
