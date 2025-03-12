//
//  EmotionColumn.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 12.03.2025.
//

import UIKit
import SnapKit

struct EmotionSegment {
    let percentage: CGFloat
    let color: UIColor
}

class EmotionColumn: UIView {
    
    private var segments: [EmotionSegment] = []
    
    init(segments: [EmotionSegment]) {
        super.init(frame: .zero)
        self.segments = segments
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func createGradientLayer(colors: [UIColor], frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = frame
        gradientLayer.cornerRadius = 8
        return gradientLayer
    }
    
    func setupView() {
        self.subviews.forEach { $0.removeFromSuperview() }
        
        guard !segments.isEmpty else {
            self.backgroundColor = .emptyEmotionColumn
            return
        }
        
        var previousView: UIView?
        
        for segment in segments.reversed() {
            let segmentView = UIView()
            segmentView.clipsToBounds = true
            segmentView.layer.cornerRadius = 10
            
            segmentView.backgroundColor = segment.color
            
            addSubview(segmentView)
            
            segmentView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(segment.percentage / 100)
                
                if let previous = previousView {
                    make.bottom.equalTo(previous.snp.top).offset(-4)
                } else {
                    make.bottom.equalToSuperview()
                }
            }
            
            let percentageLabel = UILabel()
            percentageLabel.text = "\(Int(segment.percentage))%"
            percentageLabel.font = UIFont(name: "VelaSans-Bold", size: 12)
            percentageLabel.textColor = .textSecondary
            percentageLabel.textAlignment = .center
            segmentView.addSubview(percentageLabel)
            
            percentageLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            previousView = segmentView
        }
        
        setNeedsLayout()
    }
    
    func gradientColors(for color: UIColor) -> [UIColor] {
        switch color {
        case UIColor.green:
            return [UIColor(red: 0.2, green: 1, blue: 0.73, alpha: 1), UIColor(red: 0, green: 1, blue: 0.33, alpha: 1)]
        case UIColor.yellow:
            return [UIColor(red: 1, green: 1, blue: 0.2, alpha: 1), UIColor(red: 1, green: 0.67, blue: 0, alpha: 1)]
        case UIColor.red:
            return [UIColor(red: 1, green: 0.33, blue: 0.2, alpha: 1), UIColor(red: 1, green: 0, blue: 0, alpha: 1)]
        case UIColor.blue:
            return [UIColor(red: 0.2, green: 0.87, blue: 1, alpha: 1), UIColor(red: 0, green: 0.67, blue: 1, alpha: 1)]
        default:
            return [color, color]
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        clipsToBounds = true
        
        for segmentView in subviews {
            segmentView.layer.sublayers?.forEach {
                if $0 is CAGradientLayer {
                    $0.removeFromSuperlayer()
                }
            }
            
            let gradientLayer = createGradientLayer(
                colors: gradientColors(for: segmentView.backgroundColor ?? .gray),
                frame: segmentView.bounds
            )
            
            segmentView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
