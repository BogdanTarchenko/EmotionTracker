//
//  UIViewController+Extensions.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 26.02.2025.
//

import UIKit

// MARK: - Configure Navigation Bar

extension UIViewController {
    func configureNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
            
            navigationBar.isTranslucent = true
            navigationBar.backgroundColor = .clear
            navigationBar.isHidden = true
            navigationBar.isUserInteractionEnabled = false
        }
    }
}
