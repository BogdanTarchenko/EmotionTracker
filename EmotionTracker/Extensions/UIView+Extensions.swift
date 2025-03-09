//
//  UIView+Extensions.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 10.03.2025.
//

import UIKit

extension UIView {
    func findSubview<T: UIView>(ofType type: T.Type, where predicate: (T) -> Bool) -> T? {
        for subview in subviews {
            if let typed = subview as? T, predicate(typed) {
                return typed
            }
            if let found = subview.findSubview(ofType: type, where: predicate) {
                return found
            }
        }
        return nil
    }
}
