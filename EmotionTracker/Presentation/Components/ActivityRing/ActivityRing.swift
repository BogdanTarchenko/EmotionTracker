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
    var emotionSegments: [(color: UIColor, percentage: CGFloat)] = []
    var isEmpty: Bool = true
}

final class ActivityRingView: UIView {
    var ring: ActivityRing {
        didSet {
            if ring.isEmpty {
                animateRotation()
            } else {
                stopAnimation()
            }
            setNeedsDisplay()
        }
    }
    var ringWidth: CGFloat = Metrics.ringWidth
    private var gradientLayer: CAGradientLayer?
    private var isAnimating: Bool = false
    
    init(frame: CGRect, ring: ActivityRing) {
        self.ring = ring
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        if ring.isEmpty {
            animateRotation()
        }
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
            if ring.isEmpty {
                animateRotation()
            }
        }
    }
}

// MARK: - Draw Ring

private extension ActivityRingView {
    func drawRing() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) / 2) - ringWidth
        
        drawBackgroundCircle(center: center, radius: radius)
        
        if ring.isEmpty {
            drawEmptyRingProgress(center: center, radius: radius)
        } else {
            drawSegmentedRing(center: center, radius: radius)
        }
    }
    
    func drawBackgroundCircle(center: CGPoint, radius: CGFloat) {
        let backgroundPath = UIBezierPath(arcCenter: center,
                                          radius: radius,
                                          startAngle: 0,
                                          endAngle: 2 * CGFloat.pi,
                                          clockwise: true)
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = ring.color.cgColor
        backgroundLayer.lineWidth = ringWidth
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)
    }
    
    func drawEmptyRingProgress(center: CGPoint, radius: CGFloat) {
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
    
    func drawSegmentedRing(center: CGPoint, radius: CGFloat) {
        var startAngle: CGFloat = -CGFloat.pi / 2
        
        let totalProgress = ring.emotionSegments.reduce(0) { $0 + $1.percentage }
        let isRingComplete = totalProgress >= Metrics.CapEnds.completeRingThreshold
        
        if !isRingComplete {
            drawIncompleteRing(center: center, radius: radius, startAngle: &startAngle)
        } else {
            drawCompleteRing(center: center, radius: radius, startAngle: &startAngle)
        }
    }
    
    func drawIncompleteRing(center: CGPoint, radius: CGFloat, startAngle: inout CGFloat) {
        let segmentsCount = ring.emotionSegments.count
        
        for (index, segment) in ring.emotionSegments.enumerated() {
            let endAngle = startAngle + (2 * CGFloat.pi * segment.percentage)
            
            drawSegment(center: center, radius: radius, 
                        startAngle: startAngle, endAngle: endAngle, 
                        color: segment.color, lineCap: .butt)
            
            if index == 0 {
                drawCapEnd(center: center, radius: radius, 
                           startAngle: startAngle, 
                           endAngle: startAngle + Metrics.CapEnds.capAngleSize, 
                           color: segment.color)
            }
            
            if index == segmentsCount - 1 {
                drawCapEnd(center: center, radius: radius, 
                           startAngle: endAngle - Metrics.CapEnds.capAngleSize, 
                           endAngle: endAngle, 
                           color: segment.color)
            }
            
            startAngle = endAngle
        }
    }
    
    func drawCompleteRing(center: CGPoint, radius: CGFloat, startAngle: inout CGFloat) {
        for segment in ring.emotionSegments {
            let endAngle = startAngle + (2 * CGFloat.pi * segment.percentage)
            
            drawSegment(center: center, radius: radius, 
                        startAngle: startAngle, endAngle: endAngle, 
                        color: segment.color, lineCap: .butt)
            
            startAngle = endAngle
        }
    }
    
    func drawSegment(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, 
                     color: UIColor, lineCap: CAShapeLayerLineCap) {
        let segmentPath = UIBezierPath(arcCenter: center,
                                       radius: radius,
                                       startAngle: startAngle,
                                       endAngle: endAngle,
                                       clockwise: true)
        
        let segmentLayer = CAShapeLayer()
        segmentLayer.path = segmentPath.cgPath
        segmentLayer.fillColor = UIColor.clear.cgColor
        segmentLayer.strokeColor = color.cgColor
        segmentLayer.lineWidth = ringWidth
        segmentLayer.lineCap = lineCap
        
        let gradientLayer = createGradient(for: segmentLayer, with: color)
        layer.addSublayer(gradientLayer)
    }
    
    func drawCapEnd(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        let capPath = UIBezierPath(arcCenter: center,
                                   radius: radius,
                                   startAngle: startAngle,
                                   endAngle: endAngle,
                                   clockwise: true)
        
        let capLayer = CAShapeLayer()
        capLayer.path = capPath.cgPath
        capLayer.fillColor = UIColor.clear.cgColor
        capLayer.strokeColor = color.cgColor
        capLayer.lineWidth = ringWidth
        capLayer.lineCap = .round
        
        let capGradient = createGradient(for: capLayer, with: color)
        layer.addSublayer(capGradient)
    }
    
    func createGradient(for shapeLayer: CAShapeLayer, with color: UIColor) -> CAGradientLayer {
        let brightColor = color.lighten(by: Metrics.SegmentGradient.brightenValue)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color.cgColor, brightColor.cgColor]
        gradientLayer.locations = Metrics.SegmentGradient.locations
        gradientLayer.startPoint = Metrics.SegmentGradient.startPoint
        gradientLayer.endPoint = Metrics.SegmentGradient.endPoint
        gradientLayer.frame = bounds
        gradientLayer.mask = shapeLayer
        return gradientLayer
    }
}

// MARK: - Animation Methods

private extension ActivityRingView {
    func animateRotation() {
        guard !isAnimating else { return }
        isAnimating = true
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = Metrics.Animation.rotationDuration
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .infinity
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopAnimation() {
        isAnimating = false
        layer.removeAnimation(forKey: "rotationAnimation")
    }
}
