//
//  ActivityRing.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 22.02.2025.
//

import UIKit
import SnapKit

struct ActivityRing {
    var color: UIColor
    var gradientColor: UIColor
    var progress: CGFloat
}

final class ActivityRingView: UIView {
    
    var ring: ActivityRing
    var ringWidth: CGFloat = Metrics.ringWidth
    private var gradientLayer: CAGradientLayer?
    private var isAnimating: Bool = false
    
    init(frame: CGRect, ring: ActivityRing) {
        self.ring = ring
        super.init(frame: frame)
        self.backgroundColor = .clear
        animateRotation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        drawRing()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            stopAnimation()
        } else {
            animateRotation()
        }
    }
    
    private func drawRing() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) / 2) - ringWidth
        let color = ring.color
        
        let backgroundPath = UIBezierPath(arcCenter: center,
                                          radius: radius,
                                          startAngle: 0,
                                          endAngle: 2 * CGFloat.pi,
                                          clockwise: true)
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = color.cgColor
        backgroundLayer.lineWidth = ringWidth
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)
        
        let progressPath = UIBezierPath(arcCenter: center,
                                        radius: radius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: (-CGFloat.pi / 2) + (2 * CGFloat.pi * ring.progress),
                                        clockwise: true)
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = progressPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.lineWidth = ringWidth
        progressLayer.lineCap = .round
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ring.color.withAlphaComponent(0).cgColor, ring.color.cgColor, ring.gradientColor.cgColor, ring.gradientColor.cgColor]
        gradientLayer.locations = Metrics.Gradient.locations
        gradientLayer.startPoint = Metrics.Gradient.startPoint
        gradientLayer.endPoint = Metrics.Gradient.endPoint
        gradientLayer.frame = CGRect(x: 0, y: 1.0, width: bounds.width, height: bounds.height)
        gradientLayer.mask = progressLayer
        
        layer.addSublayer(gradientLayer)
    }
    
    private func animateRotation() {
        guard !isAnimating else { return }
        isAnimating = true
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = Metrics.Animation.rotationDuration
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .infinity
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func stopAnimation() {
        isAnimating = false
        layer.removeAnimation(forKey: "rotationAnimation")
    }
}
