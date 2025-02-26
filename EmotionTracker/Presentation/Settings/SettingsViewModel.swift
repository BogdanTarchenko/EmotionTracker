//
//  SettingsViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import Foundation

class SettingsViewModel {
    var alertTime: String = ""
    
    func updateAlertTime(with time: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        alertTime = formatter.string(from: time)
    }
    
    func clearAlertTime() {
        alertTime = ""
    }
}
