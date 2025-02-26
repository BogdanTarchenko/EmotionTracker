//
//  SettingsViewController.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 24.02.2025.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    
    private var settingsTitleLabel = UILabel()
    private var profileImageView = UIImageView()
    private var profileFullNameLabel = UILabel()
    private var alertSettingsSwitcherView = SettingsSwitcherView(image: Constants.alertImage, title: Constants.alertTitle)
    private var settingsAlertTimeView = SettingsAlertTimeView(time: "20:00") // TODO: - заглушка, потом исправить
    private var addAlertButton = AddAlertButton()
    private var touchIDSettingsSwitcherView = SettingsSwitcherView(image: Constants.touchIDImage, title: Constants.touchIDTitle)
    
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
        view.addSubview(settingsAlertTimeView)
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
        
        settingsAlertTimeView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.defaultHorizontalInsets)
            make.top.equalTo(alertSettingsSwitcherView.snp.bottom).offset(Metrics.settingsAlertTimeViewTopOffset)
            make.height.equalTo(Metrics.settingsAlertTimeViewHeight)
        }
        
        addAlertButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.defaultHorizontalInsets)
            make.top.equalTo(settingsAlertTimeView.snp.bottom).offset(Metrics.addAlertButtonTopOffset)
            make.height.equalTo(Metrics.addAlertButtonHeight)
        }
        
        touchIDSettingsSwitcherView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.defaultHorizontalInsets)
            make.top.equalTo(addAlertButton.snp.bottom).offset(Metrics.touchIDSettingsSwitcherViewTopOffset)
        }
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
        static let touchIDImage: UIImage = UIImage(named: "TouchIDImg")!
        static let touchIDTitle: String = LocalizedKey.Settings.touchIDTitle
    }
}
