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
    
    private var currentIndex = 0
    private let pages: [UIViewController]
    private let containerView = UIView()
    private var isAnimating = false
    private let pageIndicatorView: PageIndicatorView
    
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
        
        configurePageIndicator()
    }
    
    func configurePageIndicator() {
        for (index, page) in pages.enumerated() {
            addChild(page)
            containerView.addSubview(page.view)
            page.view.frame = frameForPage(at: index)
            page.didMove(toParent: self)
        }
        
        updatePageIndicator()
    }
    
    func setupConstraints() {
        view.addSubview(containerView)
        view.addSubview(pageIndicatorView)
        
       containerView.snp.makeConstraints { make in
           make.edges.equalToSuperview()
       }
       
       pageIndicatorView.snp.makeConstraints { make in
           make.trailing.equalToSuperview().inset(Metrics.pageIndicatorViewInset)
           make.centerY.equalToSuperview()
       }
   }
}

// MARK: - Pagination

private extension StatisticsViewController {
    func frameForPage(at index: Int) -> CGRect {
        let viewHeight = view.bounds.height
        let yOffset = offsetForPage(index)
        
        return CGRect(x: 0, y: yOffset, width: view.bounds.width, height: viewHeight)
    }
    
    func updatePagesLayout(animated: Bool) {
        let duration = animated ? Metrics.animationDuration : 0.0
        let options: UIView.AnimationOptions = animated ? .curveEaseInOut : .curveLinear
        
        isAnimating = true
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.containerView.frame.origin.y = -self.offsetForPage(self.currentIndex)
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
        static let firstPageHeightMultiplier: Double = 0.83
        static let secondPageHeightMultiplier: Double = 1.66
        static let thirdPageHeightMultiplier: Double = 2.49
        
        static let animationDuration: CGFloat = 0.4
        
        static let pageIndicatorViewInset: CGFloat = 16
    }
    
    enum Constants {
        static let selectedColor: UIColor = .pageIndicatorActive
        static let unselectedColor: UIColor = .pageIndicatorInactive
        static let backgroundColor: UIColor = .background
    }
}
