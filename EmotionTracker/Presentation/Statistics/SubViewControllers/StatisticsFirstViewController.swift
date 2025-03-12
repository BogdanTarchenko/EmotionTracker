//
//  StatisticsFirstViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 11.03.2025.
//

import UIKit
import SnapKit

class StatisticsFirstViewController: UIViewController, StatisticsDataConfigurable {
    
    private var titleLabel = UILabel()
    private var recordsCountLabel = UILabel()
    private var pieChartView = UIView()
    
    weak var viewModel: StatisticsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    func configureWithStatisticsData(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        updateUI()
    }
    
    private func updateUI() {
        let totalEmotions = viewModel?.getEmotionsCount() ?? 0
        recordsCountLabel.text = "\(totalEmotions) \(getRecordsString(for: totalEmotions))"
        updatePieChart()
    }
    
    private func getRecordsString(for count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "записей"
        }
        
        switch lastDigit {
        case 1: return "запись"
        case 2, 3, 4: return "записи"
        default: return "записей"
        }
    }
}

// MARK: - Setup UI & Constraints

private extension StatisticsFirstViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureTitleLabel()
        configureRecordsCountLabel()
        configurePieChartView()
    }
    
    func configureTitleLabel() {
        titleLabel.text = Constants.title
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = Constants.titleColor
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
    }
    
    func configureRecordsCountLabel() {
        recordsCountLabel.font = Constants.recordsCountFont
        recordsCountLabel.textColor = Constants.recordsCountColor
        recordsCountLabel.textAlignment = .left
        recordsCountLabel.text = "0 записей"
    }
    
    func configurePieChartView() {
        pieChartView.backgroundColor = .clear
    }
    
    func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(recordsCountLabel)
        view.addSubview(pieChartView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Metrics.titleLabelInsets)
        }
        
        recordsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metrics.recordsCountTopOffset)
            make.leading.trailing.equalToSuperview().inset(Metrics.titleLabelInsets)
        }
        
        pieChartView.snp.makeConstraints { make in
            make.top.equalTo(recordsCountLabel.snp.bottom).offset(Metrics.pieChartTopOffset)
            make.leading.trailing.equalToSuperview().inset(38)
            make.width.height.equalTo(Metrics.pieChartSize)
        }
    }
    
    func updatePieChart() {
        pieChartView.subviews.forEach { $0.removeFromSuperview() }
        pieChartView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        guard let viewModel = viewModel, viewModel.getEmotionsCount() > 0 else { return }
        
        let colorPercentages = viewModel.getEmotionColorPercentages()
        
        createOverlappingCircles(colorPercentages)
    }
    
    func createOverlappingCircles(_ colorPercentages: [(color: UIColor, percentage: CGFloat)]) {
        let filteredPercentages = colorPercentages
            .filter { $0.percentage > 0 }
            .sorted { $0.percentage > $1.percentage }
        
        guard !filteredPercentages.isEmpty else {
            let noDataLabel = UILabel()
            noDataLabel.text = "Нет данных"
            noDataLabel.font = UIFont(name: "VelaSans-Medium", size: 48)
            noDataLabel.textColor = .textPrimary
            noDataLabel.textAlignment = .center
            pieChartView.addSubview(noDataLabel)
            
            noDataLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
            }
            return
        }
        
        let containerSize = Metrics.pieChartSize
        
        switch filteredPercentages.count {
        case 1:
            createSingleCircle(filteredPercentages[0], containerSize: containerSize)
            
        case 2:
            createTwoCircles(filteredPercentages, containerSize: containerSize)
            
        case 3:
            createThreeCircles(filteredPercentages, containerSize: containerSize)
            
        default:
            createFourCircles(filteredPercentages, containerSize: containerSize)
        }
    }
    
    private func addGradient(to view: UIView, colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = view.layer.cornerRadius
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func getGradientColors(for color: UIColor) -> [UIColor] {
        switch color {
        case .greenPrimary:
            return [UIColor(hex: "#33FFBB")!, UIColor(hex: "#00FF55")!]
        case .yellowPrimary:
            return [UIColor(hex: "#FFFF33")!, UIColor(hex: "#FFAA00")!]
        case .bluePrimary:
            return [UIColor(hex: "#33DDFF")!, UIColor(hex: "#00AAFF")!]
        case .redPrimary:
            return [UIColor(hex: "#FF5533")!, UIColor(hex: "#FF0000")!]
        default:
            return [color]
        }
    }
    
    private func createSingleCircle(_ percentData: (color: UIColor, percentage: CGFloat), containerSize: CGFloat) {
        let (color, percentage) = percentData
        let circleSize = containerSize * 0.8
        
        let circleView = UIView()
        circleView.backgroundColor = color
        circleView.layer.cornerRadius = circleSize / 2
        pieChartView.addSubview(circleView)
        
        let centerX = containerSize / 2
        let centerY = containerSize / 2
        
        circleView.frame = CGRect(
            x: centerX - circleSize / 2,
            y: centerY - circleSize / 2,
            width: circleSize,
            height: circleSize
        )
        
        let gradientColors = getGradientColors(for: color)
        addGradient(to: circleView, colors: gradientColors)
        
        addPercentageLabel(to: circleView, percentage: percentage)
    }
    
    private func createTwoCircles(_ percentData: [(color: UIColor, percentage: CGFloat)], containerSize: CGFloat) {
        let maxCircleSize = containerSize * 0.7
        
        let offsetsArray = [
            CGPoint(x: -containerSize * 0.1, y: -containerSize * 0.1),
            CGPoint(x: containerSize * 0.2, y: containerSize * 0.2)
        ]
        
        for (index, (color, percentage)) in percentData.enumerated() {
            let minSizeFactor: CGFloat = 0.5
            let circleSize = maxCircleSize * max(minSizeFactor, percentage * 1.6)
            
            let circleView = UIView()
            circleView.backgroundColor = color
            circleView.layer.cornerRadius = circleSize / 2
            pieChartView.addSubview(circleView)
            
            let offset = offsetsArray[index]
            let centerX = containerSize / 2 + offset.x
            let centerY = containerSize / 2 + offset.y
            
            let safeX = min(max(circleSize / 2, centerX), containerSize - circleSize / 2)
            let safeY = min(max(circleSize / 2, centerY), containerSize - circleSize / 2)
            
            circleView.frame = CGRect(
                x: safeX - circleSize / 2,
                y: safeY - circleSize / 2,
                width: circleSize,
                height: circleSize
            )
            let gradientColors = getGradientColors(for: color)
            addGradient(to: circleView, colors: gradientColors)
            addPercentageLabel(to: circleView, percentage: percentage)
        }
    }
    
    private func createThreeCircles(_ percentData: [(color: UIColor, percentage: CGFloat)], containerSize: CGFloat) {
        let maxCircleSize = containerSize * 0.55
        
        let offsetsArray = [
            CGPoint(x: -containerSize * 0.2, y: containerSize * 0.2),
            CGPoint(x: containerSize * 0.2, y: containerSize * 0.15),
            CGPoint(x: 0, y: -containerSize * 0.2)
        ]
        
        for (index, (color, percentage)) in percentData.enumerated() {
            let minSizeFactor: CGFloat = 0.45
            let circleSize = maxCircleSize * max(minSizeFactor, percentage * 1.6)
            
            let circleView = UIView()
            circleView.backgroundColor = color
            circleView.layer.cornerRadius = circleSize / 2
            pieChartView.addSubview(circleView)
            
            let offset = offsetsArray[index]
            let centerX = containerSize / 2 + offset.x
            let centerY = containerSize / 2 + offset.y
            
            let safeX = min(max(circleSize / 2, centerX), containerSize - circleSize / 2)
            let safeY = min(max(circleSize / 2, centerY), containerSize - circleSize / 2)
            
            circleView.frame = CGRect(
                x: safeX - circleSize / 2,
                y: safeY - circleSize / 2,
                width: circleSize,
                height: circleSize
            )
            let gradientColors = getGradientColors(for: color)
            addGradient(to: circleView, colors: gradientColors)
            addPercentageLabel(to: circleView, percentage: percentage)
        }
    }
    
    private func createFourCircles(_ percentData: [(color: UIColor, percentage: CGFloat)], containerSize: CGFloat) {
        let maxCircleSize = containerSize * 0.5
        
        let offsetPositions: [CGPoint] = [
            CGPoint(x: -containerSize * 0.2, y: -containerSize * 0.2),
            CGPoint(x: containerSize * 0.2, y: -containerSize * 0.2),
            CGPoint(x: -containerSize * 0.2, y: containerSize * 0.2),
            CGPoint(x: containerSize * 0.2, y: containerSize * 0.2)
        ]
        
        let limitedPercentData = Array(percentData.prefix(4))
        
        for (index, (color, percentage)) in limitedPercentData.enumerated() {
            let minSizeFactor: CGFloat = 0.4
            let circleSize = maxCircleSize * max(minSizeFactor, percentage * 1.8)
            
            let circleView = UIView()
            circleView.backgroundColor = color
            circleView.layer.cornerRadius = circleSize / 2
            pieChartView.addSubview(circleView)
            
            let offset = offsetPositions[index]
            let centerX = containerSize / 2 + offset.x
            let centerY = containerSize / 2 + offset.y
            
            let safeX = min(max(circleSize / 2, centerX), containerSize - circleSize / 2)
            let safeY = min(max(circleSize / 2, centerY), containerSize - circleSize / 2)
            
            circleView.frame = CGRect(
                x: safeX - circleSize / 2,
                y: safeY - circleSize / 2,
                width: circleSize,
                height: circleSize
            )
            let gradientColors = getGradientColors(for: color)
            addGradient(to: circleView, colors: gradientColors)
            addPercentageLabel(to: circleView, percentage: percentage)
        }
    }
    
    func addPercentageLabel(to circleView: UIView, percentage: CGFloat) {
        let percentLabel = UILabel()
        percentLabel.text = "\(Int(percentage * 100))%"
        percentLabel.font = Constants.percentLabelFont
        percentLabel.textColor = Constants.percentLabelColor
        percentLabel.textAlignment = .center
        circleView.addSubview(percentLabel)
        
        percentLabel.sizeToFit()
        percentLabel.center = CGPoint(
            x: circleView.bounds.width / 2,
            y: circleView.bounds.height / 2
        )
    }
}

// MARK: Metrics & Constants

private extension StatisticsFirstViewController {
    enum Metrics {
        static let titleLabelInsets: CGFloat = 24
        static let recordsCountTopOffset: CGFloat = 8
        static let pieChartTopOffset: CGFloat = 24
        static let pieChartSize: CGFloat = 340
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
        static let title: String = LocalizedKey.Statistics.firstVCTitle
        static let titleFont: UIFont = UIFont(name: "Gwen-Trial-Regular", size: 36)!
        static let titleColor: UIColor = .textPrimary
        
        static let recordsCountFont: UIFont = UIFont(name: "VelaSans-Regular", size: 20)!
        static let recordsCountColor: UIColor = .textPrimary
        
        static let percentLabelFont: UIFont = UIFont(name: "VelaSans-Bold", size: 20)!
        static let percentLabelColor: UIColor = .textSecondary
    }
}
