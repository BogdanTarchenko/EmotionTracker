//
//  SettingsViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import Foundation
import Combine
import UserNotifications

final class SettingsViewModel {
    private let notificationService: NotificationServiceProtocol
    private var coreDataService: CoreDataServiceProtocol
    
    @Published var isNotificationsEnabled: Bool = false
    @Published var alertTimes: [String] = []
    @Published var showPermissionAlert: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(notificationService: NotificationServiceProtocol = NotificationService.shared,
         coreDataService: CoreDataServiceProtocol = CoreDataService()) {
        self.notificationService = notificationService
        self.coreDataService = coreDataService
        
        loadSettings()
    }
    
    private func loadSettings() {
        isNotificationsEnabled = coreDataService.isNotificationsEnabled
        alertTimes = coreDataService.alertTimes
        
        notificationService.isNotificationsEnabled { [weak self] isEnabled in
            guard let self = self else { return }
            
            if self.isNotificationsEnabled && !isEnabled {
                self.isNotificationsEnabled = false
                self.coreDataService.isNotificationsEnabled = false
            }
        }
    }
    
    func toggleNotifications(_ isEnabled: Bool) {
        if isEnabled {
            notificationService.requestAuthorization { [weak self] granted in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if granted {
                        self.alertTimes.forEach { timeString in
                            if let time = self.timeFromString(timeString) {
                                self.notificationService.scheduleNotification(at: time, repeats: true)
                            }
                        }
                        self.isNotificationsEnabled = true
                        self.coreDataService.isNotificationsEnabled = true
                    } else {
                        self.isNotificationsEnabled = false
                        self.coreDataService.isNotificationsEnabled = false
                        self.showPermissionAlert = true
                        self.showNotificationSettingsInstructions()
                    }
                }
            }
        } else {
            notificationService.removeAllNotifications()
            isNotificationsEnabled = false
            coreDataService.isNotificationsEnabled = false
        }
    }
    
    private func showNotificationSettingsInstructions() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .denied:
                    self.showPermissionAlert = true
                case .notDetermined:
                    break
                case .authorized:
                    self.isNotificationsEnabled = true
                case .provisional, .ephemeral:
                    self.isNotificationsEnabled = true
                @unknown default:
                    break
                }
            }
        }
    }
    
    func addAlertTime(_ time: String) {
        alertTimes.append(time)
        coreDataService.alertTimes = alertTimes
        
        if isNotificationsEnabled {
            if let time = timeFromString(time) {
                notificationService.scheduleNotification(at: time, repeats: true)
            }
        }
    }
    
    func removeAlertTime(at index: Int) {
        guard index < alertTimes.count else { return }
        let removedTime = alertTimes[index]
        alertTimes.remove(at: index)
        coreDataService.alertTimes = alertTimes
        
        if isNotificationsEnabled {
            notificationService.removeNotification(for: removedTime)
        }
    }
    
    private func timeFromString(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: timeString)
    }
}
