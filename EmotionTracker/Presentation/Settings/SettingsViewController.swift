//
//  SettingsViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 24.02.2025.
//

import UIKit
import SnapKit
import Combine

class SettingsViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    
    private let viewModel: SettingsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var settingsTitleLabel = UILabel()
    private var profileImageView = UIImageView()
    private var profileFullNameLabel = UILabel()
    private var alertSettingsSwitcherView = SettingsSwitcherView(image: Constants.alertImage, title: Constants.alertTitle)
    
    private lazy var alertsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Metrics.minimumLineSpacing
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private var addAlertButton = AddAlertButton()
    private var touchIDSettingsSwitcherView = SettingsSwitcherView(image: Constants.faceIDImage, title: Constants.faceIDTitle)
    
    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupButtonActions()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
    }
}

// MARK: - Setup UI & Constraints

private extension SettingsViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        configureNavigationBar()
        configureSettingsTitleLabel()
        configureProfileImageView()
        configureProfileFullNameLabel()
        setupCollectionView()
        setupSwitchers()
    }
    
    func setupCollectionView() {
        alertsCollectionView.register(
            SettingsAlertTimeCollectionViewCell.self,
            forCellWithReuseIdentifier: SettingsAlertTimeCollectionViewCell.reuseIdentifier
        )
        alertsCollectionView.dataSource = self
        alertsCollectionView.delegate = self
    }
    
    func configureSettingsTitleLabel() {
        settingsTitleLabel.text = Constants.settingsTitle
        settingsTitleLabel.font = Constants.settingsTitleLabelFont
        settingsTitleLabel.textColor = Constants.settingsTitleLabelTextColor
        settingsTitleLabel.textAlignment = .left
    }
    
    func configureProfileImageView() {
        profileImageView.image = Constants.defaultProfileImage
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
    }
    
    func configureProfileFullNameLabel() {
        profileFullNameLabel.text = Constants.defaultProfileFullNameLabelText
        profileFullNameLabel.font = Constants.defaultProfileFullNameLabelFont
        profileFullNameLabel.textColor = Constants.defaultProfileFullNameLabelTextColor
        profileFullNameLabel.textAlignment = .center
    }
    
    func setupConstraints() {
        view.addSubview(settingsTitleLabel)
        view.addSubview(profileImageView)
        view.addSubview(profileFullNameLabel)
        view.addSubview(alertSettingsSwitcherView)
        view.addSubview(alertsCollectionView)
        view.addSubview(addAlertButton)
        view.addSubview(touchIDSettingsSwitcherView)
        
        settingsTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metrics.settingsTitleLabelLeadingEdgeInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(settingsTitleLabel.snp.bottom).offset(Metrics.profileImageViewTopOffset)
            make.size.equalTo(Metrics.profileImageViewSize)
        }
        
        profileFullNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(Metrics.profileFullNameLabelTopOffset)
        }
        
        alertSettingsSwitcherView.snp.makeConstraints { make in
            make.top.equalTo(profileFullNameLabel.snp.bottom).offset(Metrics.alertSettingsSwitcherViewTopOffset)
            make.horizontalEdges.equalToSuperview().inset(Metrics.defaultHorizontalInsets)
        }
        
        alertsCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.defaultHorizontalInsets)
            make.top.equalTo(alertSettingsSwitcherView.snp.bottom).offset(Metrics.settingsAlertTimeViewTopOffset)
            make.height.equalTo(0)
        }
        
        addAlertButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.defaultHorizontalInsets)
            make.top.equalTo(alertsCollectionView.snp.bottom).offset(Metrics.addAlertButtonTopOffset)
            make.height.equalTo(Metrics.addAlertButtonHeight)
        }
        
        touchIDSettingsSwitcherView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.defaultHorizontalInsets)
            make.top.equalTo(addAlertButton.snp.bottom).offset(Metrics.touchIDSettingsSwitcherViewTopOffset)
        }
    }
    
    func setupSwitchers() {
        alertSettingsSwitcherView.onSwitchChanged = { [weak self] isOn in
            self?.viewModel.toggleNotifications(isOn)
        }
        
        touchIDSettingsSwitcherView.onSwitchChanged = { [weak self] isOn in
            self?.viewModel.toggleBiometric(isOn)
        }
    }
    
    func bindViewModel() {
        viewModel.$isNotificationsEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.alertSettingsSwitcherView.setSwitchState(isEnabled)
            }
            .store(in: &cancellables)
        
        viewModel.$showPermissionAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showAlert in
                if showAlert {
                    self?.showNotificationPermissionAlert()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$alertTimes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadCollectionView()
            }
            .store(in: &cancellables)
        
        viewModel.$isBiometricEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.touchIDSettingsSwitcherView.setSwitchState(isEnabled)
            }
            .store(in: &cancellables)
    }
    
    private func showNotificationPermissionAlert() {
        let alert = UIAlertController(
            title: "Уведомления отключены",
            message: "Для работы напоминаний необходимо разрешить отправку уведомлений. Вы можете включить их в настройках приложения.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - Button Actions

private extension SettingsViewController {
    func setupButtonActions() {
        addAlertButton.onButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            if !self.viewModel.isNotificationsEnabled {
                self.showNotificationsAlert()
                return
            }
            
            TimePickerManager.showTimePicker(on: self) { [weak self] selectedTime in
                let timeString = selectedTime.toString(format: "HH:mm")
                self?.viewModel.addAlertTime(timeString)
            }
        }
    }
    
    private func showNotificationsAlert() {
        let alert = UIAlertController(
            title: "Уведомления отключены",
            message: "Для добавления напоминаний необходимо включить уведомления",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Включить", style: .default) { [weak self] _ in
            self?.viewModel.toggleNotifications(true)
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UICollectionView Methods

private extension SettingsViewController {
    func updateCollectionViewHeight() {
        alertsCollectionView.layoutIfNeeded()
        alertsCollectionView.collectionViewLayout.invalidateLayout()
        
        let contentHeight = alertsCollectionView.collectionViewLayout.collectionViewContentSize.height
        let flowLayout = alertsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let spacing = flowLayout?.minimumLineSpacing ?? Metrics.minimumLineSpacing
        
        let isSmallScreen = UIScreen.main.bounds.height <= Metrics.smallScreenHeight
        let cellHeight: CGFloat = isSmallScreen ? Metrics.smallCellHeight : Metrics.cellHeight
        let maxCells = isSmallScreen ? 2 : 3
        
        let maxHeight = (CGFloat(maxCells) * cellHeight) + (CGFloat(maxCells - 1) * spacing)
        let height = min(contentHeight, maxHeight)
        
        alertsCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    
    func reloadCollectionView() {
        alertsCollectionView.reloadData()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.updateCollectionViewHeight()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            let lastItemIndex = self.viewModel.alertTimes.count - 1
            guard lastItemIndex >= 0 else { return }
            let lastIndexPath = IndexPath(item: lastItemIndex, section: 0)
            
            self.alertsCollectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
        })
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.alertTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SettingsAlertTimeCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! SettingsAlertTimeCollectionViewCell
        
        let time = viewModel.alertTimes[indexPath.row]
        cell.configure(with: time)
        
        cell.onButtonTapped = { [weak self] in
            self?.viewModel.removeAlertTime(at: indexPath.row)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isSmallScreen = UIScreen.main.bounds.height <= Metrics.smallScreenHeight
        let cellHeight: CGFloat = isSmallScreen ? Metrics.smallCellHeight : Metrics.cellHeight
        return CGSize(width: collectionView.bounds.width, height: cellHeight)
    }
}

// MARK: - Metrics & Constants

private extension SettingsViewController {
    enum Metrics {
        static let settingsTitleLabelLeadingEdgeInset: CGFloat = 24
        static let profileImageViewTopOffset: CGFloat = 32
        static let profileImageViewSize: CGFloat = 96
        static let profileFullNameLabelTopOffset: CGFloat = 8
        static let alertSettingsSwitcherViewTopOffset: CGFloat = 32
        static let defaultHorizontalInsets: CGFloat = 24
        static let settingsAlertTimeViewTopOffset: CGFloat = 16
        static let settingsAlertTimeViewHeight: CGFloat = 64
        static let addAlertButtonTopOffset: CGFloat = 16
        static let addAlertButtonHeight: CGFloat = 56
        static let touchIDSettingsSwitcherViewTopOffset: CGFloat = 24
        static let cellHeight: CGFloat = 64
        static let bottomEdgeInset: CGFloat = 32
        static let minimumLineSpacing: CGFloat = 16
        static let smallCellHeight: CGFloat = 56
        static let smallScreenHeight: CGFloat = 667
    }
    
    enum Constants {
        static let backgroundColor: UIColor = .background
        static let settingsTitle: String = LocalizedKey.Settings.settingsTitle
        static let settingsTitleLabelFont: UIFont = UIFont(name: "Gwen-Trial-Regular", size: 36)!
        static let settingsTitleLabelTextColor: UIColor = .textPrimary
        static let defaultProfileImage: UIImage = UIImage(named: "DefaultProfileImage")!
        static let defaultProfileFullNameLabelText: String = LocalizedKey.Settings.defaultProfileFullNameLabelText
        static let defaultProfileFullNameLabelFont: UIFont = UIFont(name: "VelaSans-Bold", size: 24)!
        static let defaultProfileFullNameLabelTextColor: UIColor = .textPrimary
        static let alertImage: UIImage = UIImage(named: "AlertImg")!
        static let alertTitle: String = LocalizedKey.Settings.alertTitle
        static let faceIDImage: UIImage = UIImage(systemName: "faceid")!
        static let faceIDTitle: String = LocalizedKey.Settings.faceIDTitle
    }
}
