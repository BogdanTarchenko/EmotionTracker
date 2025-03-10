//
//  PageIndicatorView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 11.03.2025.
//

import UIKit
import SnapKit

class PageIndicatorView: UIStackView {
    private var dots: [UIView] = []
    private let selectedColor: UIColor
    private let unselectedColor: UIColor
    
    init(pagesCount: Int, selectedColor: UIColor, unselectedColor: UIColor) {
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        super.init(frame: .zero)
        
        axis = .vertical
        alignment = .center
        spacing = 4
        
        setupDots(count: pagesCount)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDots(count: Int) {
        for _ in 0..<count {
            let dot = UIView()
            dot.layer.cornerRadius = 2
            dot.backgroundColor = unselectedColor
            addArrangedSubview(dot)
            
            dot.snp.makeConstraints { make in
                make.width.height.equalTo(4)
            }
            
            dots.append(dot)
        }
    }
    
    func updateIndicator(currentIndex: Int) {
        for (index, dot) in dots.enumerated() {
            dot.backgroundColor = index == currentIndex ? selectedColor : unselectedColor
        }
    }
}
