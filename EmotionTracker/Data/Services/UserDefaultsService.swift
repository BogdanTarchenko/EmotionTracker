//
//  UserDefaultsService.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 08.03.2025.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    var dailyGoal: Int { get set }
    var lastRecordDate: String? { get set }
    var currentStreak: Int { get set }
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let dailyGoal = "dailyEmotionGoal"
        static let lastRecordDate = "lastRecordDate"
        static let currentStreak = "currentStreak"
    }
    
    // MARK: - DailyGoal
    
    var dailyGoal: Int {
        get {
            return userDefaults.integer(forKey: Keys.dailyGoal) == 0 ? 3 : userDefaults.integer(forKey: Keys.dailyGoal)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.dailyGoal)
        }
    }
    
    // MARK: - LastRecordDate
    
    var lastRecordDate: String? {
        get {
            return userDefaults.string(forKey: Keys.lastRecordDate)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.lastRecordDate)
        }
    }
    
    // MARK: - CurrentStreak
    
    var currentStreak: Int {
        get {
            return userDefaults.integer(forKey: Keys.currentStreak)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.currentStreak)
        }
    }
}
