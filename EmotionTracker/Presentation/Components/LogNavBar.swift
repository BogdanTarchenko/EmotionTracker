//
//  LogNavBar.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 23.02.2025.
//

import UIKit
import SnapKit

final class LogNavBar: UIView {
    struct ViewModel {
        let totalLogs: Int
        let dailyGoal: Int
        let streakDays: Int
    }
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Metrics.stackViewSpacing
        stack.alignment = .center
        return stack
    }()
    
    private var totalLogsContainer = UIStackView()
    private var dailyGoalContainer = UIStackView()
    private var streakContainer = UIStackView()
    
    private let totalLogsLabel = UILabel()
    
    private let dailyGoalTitleLabel = UILabel()
    private let dailyGoalValueLabel = UILabel()
    
    private let streakTitleLabel = UILabel()
    private let streakValueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        totalLogsContainer = createContainerView()
        dailyGoalContainer = createContainerView()
        streakContainer = createContainerView()
        
        setupValueLabel(totalLogsLabel, in: totalLogsContainer)
        
        setupTitleLabel(dailyGoalTitleLabel, in: dailyGoalContainer)
        setupValueLabel(dailyGoalValueLabel, in: dailyGoalContainer)
        
        setupTitleLabel(streakTitleLabel, in: streakContainer)
        setupValueLabel(streakValueLabel, in: streakContainer)
        
        stackView.addArrangedSubview(totalLogsContainer)
        stackView.addArrangedSubview(dailyGoalContainer)
        stackView.addArrangedSubview(streakContainer)
        
        addSubview(stackView)
        setupConstraints()
    }
    
    private func setupTitleLabel(_ label: UILabel, in container: UIStackView) {
        label.textColor = .textPrimary
        label.font = Constants.titleLabelFont
        label.textAlignment = .center
        container.addArrangedSubview(label)
    }
    
    private func setupValueLabel(_ label: UILabel, in container: UIStackView) {
        label.textColor = .textPrimary
        label.font = Constants.valueLabelFont
        label.textAlignment = .center
        container.addArrangedSubview(label)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
    
    private func createContainerView() -> UIStackView {
        let view = UIStackView()
        view.backgroundColor = Constants.containerViewBackgroundColor
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = Metrics.containerViewSpacing
        view.layer.cornerRadius = Metrics.containerViewCornerRadius
        view.layer.masksToBounds = true
        
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = Metrics.containerViewEdgeInsets
        return view
    }
    
    func configure(with viewModel: ViewModel) {
        totalLogsLabel.text = "\(viewModel.totalLogs) \(pluralize(count: viewModel.totalLogs, one: Constants.oneNote, few: Constants.fewNotes, many: Constants.manyNotes))"
        
        dailyGoalTitleLabel.text = Constants.dailyGoalLabelText
        dailyGoalValueLabel.text = "\(viewModel.dailyGoal) \(pluralize(count: viewModel.dailyGoal, one: Constants.oneNote, few: Constants.fewNotes, many: Constants.manyNotes))"
        
        streakTitleLabel.text = Constants.streakLabelText
        streakValueLabel.text = "\(viewModel.streakDays) \(pluralize(count: viewModel.streakDays, one: Constants.oneDay, few: Constants.fewDays, many: Constants.manyDays))"
        
        totalLogsContainer.snp.remakeConstraints { make in
            make.height.equalTo(Metrics.containerViewHeight)
        }
        
        dailyGoalContainer.snp.remakeConstraints { make in
            make.height.equalTo(Metrics.containerViewHeight)
        }
        
        streakContainer.snp.remakeConstraints { make in
            make.height.equalTo(Metrics.containerViewHeight)
        }
    }
}

// MARK: - Metrics & Constants

private extension LogNavBar {
    enum Metrics {
        static let stackViewSpacing: CGFloat = 8
        static let containerViewSpacing: CGFloat = 2
        static let containerViewCornerRadius: CGFloat = 16
        static let containerViewEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let containerViewHeight: CGFloat = 32
    }
    
    enum Constants {
        static let containerViewBackgroundColor: UIColor = .buttonSecondary
        static let titleLabelFont: UIFont = UIFont(name: "VelaSans-Regular", size: 12)!
        static let valueLabelFont: UIFont = UIFont(name: "VelaSans-Bold", size: 12)!
        static let dailyGoalLabelText: String = LocalizedKey.LogNavBar.dailyGoalLabelText
        static let streakLabelText: String = LocalizedKey.LogNavBar.streakLabelText
        static let oneNote: String = LocalizedKey.LogNavBar.oneNote
        static let fewNotes: String = LocalizedKey.LogNavBar.fewNotes
        static let manyNotes: String = LocalizedKey.LogNavBar.manyNotes
        static let oneDay: String = LocalizedKey.LogNavBar.oneDay
        static let fewDays: String = LocalizedKey.LogNavBar.fewDays
        static let manyDays: String = LocalizedKey.LogNavBar.manyDays
    }
}
