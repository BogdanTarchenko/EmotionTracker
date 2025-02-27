//
//  LogViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 22.02.2025.
//

import UIKit
import SnapKit

final class LogViewController: UIViewController {
    weak var coordinator: LogCoordinator?
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var logNavBar = LogNavBar()
    private var logTitleLabel = UILabel()
    private var activityRingView = UIView()
    private var activityRing: ActivityRingView?
    private var addNoteButton = AddNoteButton()
    private var cardStackView = UIStackView()
    
    // TODO: - Тестовые карточки, поэтому хардкод, потом исправить.
    private var firstEmotionCard = EmotionCardView(time: "вчера, 23:40",
                                                   emotion: "выгорание",
                                                   emotionColor: .blue,
                                                   icon: UIImage(named: "TestEmotionImg"))
    
    private var secondEmotionCard = EmotionCardView(time: "вчера, 23:40",
                                                    emotion: "выгорание",
                                                    emotionColor: .green,
                                                    icon: UIImage(named: "TestEmotionImg"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Setup UI & Constraints

private extension LogViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureNavigationBar()
        configureScrollView()
        configureLogNavBar()
        configureLogTitleLabel()
        configureActivityRing()
        configureCardStackView()
    }
    
    func configureScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
    }
    
    func configureLogNavBar() {
        logNavBar.configure(with: LogNavBar.ViewModel(totalLogs: 4, dailyGoal: 2, streakDays: 0))
    }
    
    func configureLogTitleLabel() {
        logTitleLabel.text = Constants.logTitleLabelText
        logTitleLabel.textColor = Constants.logTitleLabelTextColor
        logTitleLabel.font = Constants.logTitleLabelFont
        logTitleLabel.numberOfLines = Metrics.logTitleLabelNumberOfLines
    }
    
    func configureActivityRing() {
        let frame = activityRingView.bounds
        activityRing = ActivityRingView(frame: frame, ring: ActivityRing(color: .ringEmpty, gradientColor: .ringDefault, progress: 0.5))
    }
    
    func configureCardStackView() {
        cardStackView.axis = .vertical
        cardStackView.spacing = Metrics.cardStackViewSpacing
    }
    
    func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logNavBar)
        contentView.addSubview(logTitleLabel)
        contentView.addSubview(activityRingView)
        contentView.addSubview(cardStackView)
        cardStackView.addArrangedSubview(firstEmotionCard)
        cardStackView.addArrangedSubview(secondEmotionCard)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        logNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.horizontalEdgesInset)
            make.top.equalToSuperview()
            make.height.equalTo(Metrics.topEdgeOffset)
        }
        
        logTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.horizontalEdgesInset)
            make.top.equalTo(logNavBar.snp.bottom).offset(Metrics.topEdgeOffset)
        }
        
        if let activityRing = activityRing {
            activityRingView.addSubview(activityRing)
            activityRing.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        activityRingView.snp.makeConstraints { make in
            make.top.equalTo(logTitleLabel.snp.bottom).offset(Metrics.topEdgeOffset)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(activityRingView.snp.width)
        }
        activityRingView.addSubview(addNoteButton)
        addNoteButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        cardStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.horizontalEdgesInset)
            make.top.equalTo(activityRingView.snp.bottom).offset(Metrics.topEdgeOffset)
            make.bottom.equalToSuperview().inset(Metrics.bottomEdgeInset)
        }
    }
}

private extension LogViewController {
    enum Metrics {
        static let logTitleLabelNumberOfLines: Int = 2
        static let cardStackViewSpacing: CGFloat = 8
        static let horizontalEdgesInset: CGFloat = 24
        static let topEdgeOffset: CGFloat = 32
        static let bottomEdgeInset: CGFloat = 32
    }
    
    enum Constants {
        static let logTitleLabelText: String = LocalizedKey.Log.logTitle
        static let logTitleLabelTextColor: UIColor = .textPrimary
        static let logTitleLabelFont: UIFont = UIFont(name: "Gwen-Trial-Regular", size: 36)!
        static let backgroundColor: UIColor = .background
    }
}
