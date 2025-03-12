//
//  PageIndicatorView.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 24.02.2025.
//

import UIKit
import SnapKit

class StatisticsViewController: UIViewController {
    weak var coordinator: StatisticsCoordinator!
    
    private let viewModel = StatisticsViewModel()
    
    private var currentIndex = 0
    private let pages: [UIViewController]
    private let containerView = UIView()
    private var isAnimating = false
    private let pageIndicatorView: PageIndicatorView
    private let horizontalTabView = HorizontalTabView()
    
    private var containerTopConstraint: Constraint?
    private var backgroundView = UIView()
    
    init() {
        pages = [
            StatisticsFirstViewController(),
            StatisticsSecondViewController(),
            StatisticsThirdViewController(),
            StatisticsFourthViewController()
        ]
        
        pageIndicatorView = PageIndicatorView(
            pagesCount: pages.count,
            selectedColor: Constants.selectedColor,
            unselectedColor: Constants.unselectedColor
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupGestures()
        
        loadTestData()
        
        setupStatisticsPages()
    }
    
    private func loadTestData() {
        let testCards = createTestCards()
        viewModel.updateWithTestData(testCards)
    }
    
    private func setupStatisticsPages() {
        for (_, page) in pages.enumerated() {
            if let statsPage = page as? StatisticsDataConfigurable {
                statsPage.configureWithStatisticsData(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Setup Gestures & Swipes

private extension StatisticsViewController {
    func setupGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard !isAnimating else { return }
        
        switch gesture.direction {
        case .up where currentIndex < pages.count - 1:
            currentIndex += 1
        case .down where currentIndex > 0:
            currentIndex -= 1
        default:
            return
        }
        
        updatePagesLayout(animated: true)
        updatePageIndicator()
    }
}

// MARK: - Setup UI & Constraints

private extension StatisticsViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureNavigationBar()
        configureBackgroundView()
        configurePageIndicator()
    }
    
    func configureBackgroundView() {
        backgroundView.backgroundColor = Constants.backgroundColor
    }
    
    func configurePageIndicator() {
        for (_, page) in pages.enumerated() {
            addChild(page)
            containerView.addSubview(page.view)
            page.didMove(toParent: self)
        }
        
        updatePageIndicator()
    }
    
    func setupConstraints() {
        view.addSubview(containerView)
        view.addSubview(backgroundView)
        view.addSubview(horizontalTabView)
        view.addSubview(pageIndicatorView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            containerTopConstraint = make.top.equalTo(horizontalTabView.snp.bottom).constraint
        }
        
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(horizontalTabView.snp.top)
        }
        
        pageIndicatorView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metrics.pageIndicatorViewInset)
            make.centerY.equalToSuperview()
        }
        
        horizontalTabView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        for (index, page) in pages.enumerated() {
            page.view.snp.makeConstraints { make in
                make.top.equalTo(containerView).offset(offsetForPage(index))
                make.leading.trailing.equalTo(containerView)
            }
        }
    }
}

// MARK: - Pagination

private extension StatisticsViewController {
    func updatePagesLayout(animated: Bool) {
        let duration = animated ? Metrics.animationDuration : 0.0
        let options: UIView.AnimationOptions = animated ? .curveEaseInOut : .curveLinear
        
        isAnimating = true
        
        containerView.snp.updateConstraints { make in
            make.top.equalTo(horizontalTabView.snp.bottom).offset(-offsetForPage(currentIndex))
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.isAnimating = false
        }
    }
    
    func offsetForPage(_ index: Int) -> CGFloat {
        let viewHeight = view.bounds.height
        
        switch index {
        case 0: return 0
        case 1: return viewHeight * Metrics.firstPageHeightMultiplier
        case 2: return viewHeight * Metrics.secondPageHeightMultiplier
        case 3: return viewHeight * Metrics.thirdPageHeightMultiplier
        default: return 0
        }
    }
}

// MARK: - Page Indicator

private extension StatisticsViewController {
    func updatePageIndicator() {
        pageIndicatorView.updateIndicator(currentIndex: currentIndex)
    }
}

// MARK: - Metrics & Constants

private extension StatisticsViewController {
    enum Metrics {
        static let firstPageHeightMultiplier: Double = 0.625
        static let secondPageHeightMultiplier: Double = 1.25
        static let thirdPageHeightMultiplier: Double = 1.875
        
        static let animationDuration: CGFloat = 0.4
        
        static let pageIndicatorViewInset: CGFloat = 0
    }
    
    enum Constants {
        static let selectedColor: UIColor = .pageIndicatorActive
        static let unselectedColor: UIColor = .pageIndicatorInactive
        static let backgroundColor: UIColor = .background
    }
}

// MARK: - Test Data

private extension StatisticsViewController {
    func createTestCards() -> [EmotionCardViewModel] {
        let yesterdayCard1 = EmotionCardViewModel(
            time: "вчера, 18:45",
            emotion: "Спокойствие",
            emotionColor: .green,
            icon: UIImage(named: "TestEmotionGreenImg"),
            selectedTags: ["Дом", "Один"],
            tagsBySection: [
                [],
                [("Один", 0)],
                [("Дом", 0)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 1, tag: "Один"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Дом")
            ]
        )
        
        let yesterdayCard2 = EmotionCardViewModel(
            time: "вчера, 10:15",
            emotion: "Интерес",
            emotionColor: .green,
            icon: UIImage(named: "TestEmotionBlueImg"),
            selectedTags: ["Встреча", "Работа"],
            tagsBySection: [
                [],
                [("Работа", 2)],
                [("Встреча", 4)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 1, tag: "Работа"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Встреча")
            ]
        )
        
        let twoDaysAgoCard1 = EmotionCardViewModel(
            time: "2 дня назад, 13:20",
            emotion: "Радость",
            emotionColor: .green,
            icon: UIImage(named: "TestEmotionYellowImg"),
            selectedTags: ["Друзья", "Праздник"],
            tagsBySection: [
                [("Праздник", 1)],
                [("Друзья", 0)],
                []
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 0, tag: "Праздник"),
                EditNoteViewModel.SectionTag(section: 1, tag: "Друзья")
            ]
        )
        
        let twoDaysAgoCard2 = EmotionCardViewModel(
            time: "2 дня назад, 19:45",
            emotion: "Гордость",
            emotionColor: .green,
            icon: UIImage(named: "TestEmotionGreenImg"),
            selectedTags: ["Достижение", "Спорт"],
            tagsBySection: [
                [("Достижение", 3)],
                [],
                [("Спорт", 2)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 0, tag: "Достижение"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Спорт")
            ]
        )
        
        let threeDaysAgoCard1 = EmotionCardViewModel(
            time: "3 дня назад, 10:15",
            emotion: "Усталость",
            emotionColor: .green,
            icon: UIImage(named: "TestEmotionBlueImg"),
            selectedTags: ["Работа", "Стресс"],
            tagsBySection: [
                [],
                [("Работа", 2)],
                [("Стресс", 1)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 1, tag: "Работа"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Стресс")
            ]
        )
        
        let threeDaysAgoCard2 = EmotionCardViewModel(
            time: "3 дня назад, 16:30",
            emotion: "Облегчение",
            emotionColor: .yellow,
            icon: UIImage(named: "TestEmotionGreenImg"),
            selectedTags: ["Отдых", "Природа"],
            tagsBySection: [
                [("Отдых", 0)],
                [],
                [("Природа", 5)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 0, tag: "Отдых"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Природа")
            ]
        )
        
        let fourDaysAgoCard1 = EmotionCardViewModel(
            time: "4 дня назад, 19:30",
            emotion: "Вдохновение",
            emotionColor: .green,
            icon: UIImage(named: "TestEmotionYellowImg"),
            selectedTags: ["Хобби", "Творчество"],
            tagsBySection: [
                [("Творчество", 2)],
                [],
                [("Хобби", 3)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 0, tag: "Творчество"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Хобби")
            ]
        )
        
        let fourDaysAgoCard2 = EmotionCardViewModel(
            time: "4 дня назад, 09:15",
            emotion: "Бодрость",
            emotionColor: .yellow,
            icon: UIImage(named: "TestEmotionBlueImg"),
            selectedTags: ["Утро", "Кофе"],
            tagsBySection: [
                [],
                [("Утро", 5)],
                [("Кофе", 6)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 1, tag: "Утро"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Кофе")
            ]
        )
        
        let todayCard1 = EmotionCardViewModel(
            time: "сегодня, 10:30",
            emotion: "Энтузиазм",
            emotionColor: .yellow,
            icon: UIImage(named: "TestEmotionYellowImg"),
            selectedTags: ["Проект", "Идея"],
            tagsBySection: [
                [("Идея", 4)],
                [("Проект", 1)],
                []
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 0, tag: "Идея"),
                EditNoteViewModel.SectionTag(section: 1, tag: "Проект")
            ]
        )
        
        let todayCard2 = EmotionCardViewModel(
            time: "сегодня, 14:15",
            emotion: "Удовлетворение",
            emotionColor: .yellow,
            icon: UIImage(named: "TestEmotionGreenImg"),
            selectedTags: ["Обед", "Отдых"],
            tagsBySection: [
                [("Отдых", 0)],
                [],
                [("Обед", 7)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 0, tag: "Отдых"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Обед")
            ]
        )
        
        return [
            todayCard1, todayCard2,
            yesterdayCard1, yesterdayCard2,
            twoDaysAgoCard1, twoDaysAgoCard2,
            threeDaysAgoCard1, threeDaysAgoCard2,
            fourDaysAgoCard1, fourDaysAgoCard2
        ]
    }
}

// MARK: - StatisticsDataConfigurable Protocol

protocol StatisticsDataConfigurable: AnyObject {
    func configureWithStatisticsData(viewModel: StatisticsViewModel)
}
