//
//  SettingsViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import Foundation

class SettingsViewModel {
    var alertTimes: [String] = []
    
    func addAlertTime(_ time: String) {
        alertTimes.append(time)
    }
    
    func removeAlertTime(at index: Int) {
        guard index < alertTimes.count else { return }
        alertTimes.remove(at: index)
    }
}
