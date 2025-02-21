//
//  AnimatedGradientView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 21.02.2025.
//

import UIKit

class AnimatedGradientView: UIView {
    
    private let gradientLayers: [CAGradientLayer]
    private let animationDuration: CFTimeInterval
    private let animationRadius: CGFloat
    
    init(frame: CGRect,
         colors: [UIColor],
         positions: [(x: CGFloat, y: CGFloat, radius: CGFloat)],
         animationDuration: CFTimeInterval = 24,
         animationRadius: CGFloat = 150)
    {
        self.gradientLayers = (0..<colors.count).map { _ in CAGradientLayer() }
        self.animationDuration = animationDuration
        self.animationRadius = animationRadius
        super.init(frame: frame)
        setupView(colors: colors, positions: positions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(colors: [UIColor],
                           positions: [(x: CGFloat, y: CGFloat, radius: CGFloat)]) {
        for (index, gradientLayer) in gradientLayers.enumerated() {
            gradientLayer.frame = bounds
            gradientLayer.type = .radial
            gradientLayer.colors = [colors[index].cgColor, colors[index].withAlphaComponent(0.0).cgColor]
            gradientLayer.locations = [0.0, 1.0]
            
            let center = CGPoint(x: bounds.width * positions[index].x, y: bounds.height * positions[index].y)
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.bounds = CGRect(x: 0, y: 0, width: positions[index].radius * 2, height: positions[index].radius * 2)
            gradientLayer.position = center
            
            layer.addSublayer(gradientLayer)
        }
        
        animateViewMovement()
    }
    
    private func animateViewMovement() {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = animationDuration
        animation.repeatCount = .infinity
        animation.calculationMode = .paced
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                                radius: animationRadius,
                                startAngle: 0,
                                endAngle: 2 * .pi,
                                clockwise: true)
        
        animation.path = path.cgPath
        layer.add(animation, forKey: "position")
    }
}
