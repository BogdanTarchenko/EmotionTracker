//
//  AddNoteViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit
import SnapKit

class AddNoteViewController: UIViewController {
    weak var coordinator: AddNoteCoordinator?
    
    private var viewModel = AddNoteViewModel()
    
    private var navigationBar = DefaultNavBar(title: nil)
    private var emotionPicker = EmotionPicker(state: .inactive)
    
    private var container = UIView()
    
    private var selectedCircle: UIView?
    private var allCircles = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupButtonActions()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
}

private extension AddNoteViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        configureNavigationBar()
        setupColorGroups()
        configureContainer()
    }
    
    func setupColorGroups() {
        let allEmotions = viewModel.emotions
        
        let redGroup = createColorGroup(with: Array(allEmotions[0..<4]))
        redGroup.frame = CGRect(x: 0, y: 0, width: Metrics.colorGroupSize, height: Metrics.colorGroupSize)
        
        let yellowGroup = createColorGroup(with: Array(allEmotions[4..<8]))
        yellowGroup.frame = CGRect(x: Metrics.colorGroupSize, y: 0, width: Metrics.colorGroupSize, height: Metrics.colorGroupSize)
        
        let blueGroup = createColorGroup(with: Array(allEmotions[8..<12]))
        blueGroup.frame = CGRect(x: 0, y: Metrics.colorGroupSize, width: Metrics.colorGroupSize, height: Metrics.colorGroupSize)
        
        let greenGroup = createColorGroup(with: Array(allEmotions[12..<16]))
        greenGroup.frame = CGRect(x: Metrics.colorGroupSize, y: Metrics.colorGroupSize, width: Metrics.colorGroupSize, height: Metrics.colorGroupSize)
        
        [redGroup, yellowGroup, blueGroup, greenGroup].forEach { group in
            container.addSubview(group)
            for subview in group.subviews {
                allCircles.append(subview)
            }
        }
    }
    
    func configureContainer() {
        container.backgroundColor = .clear
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        container.addGestureRecognizer(panGesture)
    }
    
    func setupConstraints() {
        view.addSubview(container)
        view.addSubview(navigationBar)
        view.addSubview(emotionPicker)
        
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.defaultHorizontalInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        emotionPicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metrics.defaultHorizontalInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(Metrics.colorGroupSize * 2)
        }
    }
    
    func setupButtonActions() {
        navigationBar.onButtonTapped = {
            self.coordinator?.handleBackButtonTapped()
        }
        
        emotionPicker.onButtonTapped = { [weak self] in
            guard let self = self,
                  let selectedEmotion = self.viewModel.selectedEmotion else { return }
            self.coordinator?.showEditNote(selectedEmotion: selectedEmotion)
        }
    }
}

// MARK: - Setup Gestures

private extension AddNoteViewController {
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if gesture.state == .changed {
            let newCenter = CGPoint(x: container.center.x + translation.x, y: container.center.y + translation.y)
            
            let maxOffset: CGFloat = Metrics.maxViewOffset
            let screenCenter = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
            let minX = screenCenter.x - maxOffset, maxX = screenCenter.x + maxOffset
            let minY = screenCenter.y - maxOffset, maxY = screenCenter.y + maxOffset
            
            let clampedX = max(min(newCenter.x, maxX), minX)
            let clampedY = max(min(newCenter.y, maxY), minY)
            
            container.center = CGPoint(x: clampedX, y: clampedY)
            gesture.setTranslation(.zero, in: view)
        }
    }
    
    @objc func circleTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedCircle = gesture.view else { return }
        
        allCircles.forEach { circle in
            if let label = circle.subviews.compactMap({ $0 as? UILabel }).first {
                label.font = Constants.labelDefaultFont
            }
        }
        
        let (tapRow, tapCol) = overallGridPosition(for: tappedCircle)
        
        UIView.animate(withDuration: 0.3) {
            for circle in self.allCircles {
                if circle == tappedCircle {
                    circle.transform = CGAffineTransform(scaleX: Metrics.scaledCircleRadius/Metrics.defaultCircleRadius, y: Metrics.scaledCircleRadius/Metrics.defaultCircleRadius)
                    
                    if let label = circle.subviews.compactMap({ $0 as? UILabel }).first {
                        label.font = Constants.labelScaledFont
                        label.adjustsFontSizeToFitWidth = true
                        label.minimumScaleFactor = 0.7
                        label.numberOfLines = 1
                    }
                } else {
                    let (row, col) = self.overallGridPosition(for: circle)
                    var translationX: CGFloat = 0
                    var translationY: CGFloat = 0
                    
                    if row == tapRow {
                        translationX = (col < tapCol) ? -Metrics.shiftValue : (col > tapCol ? Metrics.shiftValue : 0)
                    }
                    if col == tapCol {
                        translationY = (row < tapRow) ? -Metrics.shiftValue : (row > tapRow ? Metrics.shiftValue : 0)
                    }
                    circle.transform = CGAffineTransform(translationX: translationX, y: translationY)
                }
            }
        }
        
        if let emotionCircle = tappedCircle as? EmotionCircleView,
           let emotionData = emotionCircle.emotion {
            viewModel.selectEmotion(emotion: (title: emotionData.title, color: emotionData.color))
        }
    }
    
    func overallGridPosition(for circle: UIView) -> (row: Int, col: Int) {
        guard let group = circle.superview else { return (0, 0) }
        let groupRowOffset = group.frame.origin.y >= Metrics.colorGroupSize ? 2 : 0
        let groupColOffset = group.frame.origin.x >= Metrics.colorGroupSize ? 2 : 0
        if let emotionCircle = circle as? EmotionCircleView {
            return (row: groupRowOffset + emotionCircle.gridRow, col: groupColOffset + emotionCircle.gridColumn)
        }
        return (0, 0)
    }
}

// MARK: - Create Color Group Method
private extension AddNoteViewController {
    func createColorGroup(with emotions: [(String, UIColor)]) -> UIView {
        let container = UIView()
        
        for (index, emotion) in emotions.enumerated() {
            let row = index / 2
            let column = index % 2
            
            let circle = EmotionCircleView()
            circle.gridRow = row
            circle.gridColumn = column
            circle.emotion = (title: emotion.0, color: emotion.1)
            circle.backgroundColor = emotion.1
            circle.layer.cornerRadius = Metrics.defaultCircleRadius / 2
            circle.clipsToBounds = true
            circle.isUserInteractionEnabled = true
            container.addSubview(circle)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(circleTapped(_:)))
            circle.addGestureRecognizer(tap)
            
            circle.snp.makeConstraints { make in
                make.width.height.equalTo(Metrics.defaultCircleRadius)
                make.leading.equalToSuperview().offset(column * (Int(Metrics.defaultCircleRadius) + 4))
                make.top.equalToSuperview().offset(row * (Int(Metrics.defaultCircleRadius) + 4))
            }
            
            let label = UILabel()
            label.text = emotion.0
            label.font = Constants.labelDefaultFont
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 0
            circle.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(4)
            }
        }
        return container
    }
}

// MARK: ViewModel Setup

private extension AddNoteViewController {
    func setupViewModel() {
        viewModel.onEmotionPickerStateChanged = { [weak self] newState in
            DispatchQueue.main.async {
                self?.emotionPicker.changeState(to: newState)
            }
        }
    }
}

// MARK: - Metrics & Constants
private extension AddNoteViewController {
    enum Metrics {
        static let defaultHorizontalInset: CGFloat = 24
        static let colorGroupSize: CGFloat = 230
        static let defaultCircleRadius: CGFloat = 112
        static let scaledCircleRadius: CGFloat = 152
        static let maxViewOffset: CGFloat = 300
        static let shiftValue: CGFloat = 20
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
        static let labelDefaultFont: UIFont = UIFont(name: "Gwen-Trial-Black", size: 10)!
        static let labelScaledFont: UIFont = UIFont(name: "Gwen-Trial-Black", size: 14)!
    }
}
