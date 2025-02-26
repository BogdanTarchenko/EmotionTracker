//
//  LocalizedKey.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 21.02.2025.
//

import Foundation

struct LocalizedKey {
    enum Welcome {
        static let welcomeTitle = NSLocalizedString("welcome_title", comment: "Welcome screen title")
        static let appleIDButtonTitle = NSLocalizedString("apple_id_button_title", comment: "Apple ID button title")
    }
    
    enum Log {
        static let logTitle = NSLocalizedString("log_title", comment: "Log screen title")
    }
    
    enum TabBar {
        static let logTabBarItemTitle = NSLocalizedString("logTabBarItem_title", comment: "Log tab bar item title")
        static let statisticsTabBarItemTitle = NSLocalizedString("statisticsTabBarItem_title", comment: "Statistics tab bar item title")
        static let settingsTabBarItemTitle = NSLocalizedString("settingsTabBarItem_title", comment: "Settings tab bar item title")
    }
    
    enum AddNoteButton {
        static let title = NSLocalizedString("addNoteButton_title", comment: "AddNoteButton title")
    }
    
    enum EmotionCardView {
        static let feelingLabelText = NSLocalizedString("feelingLabel_text", comment: "Feeling label text")
    }
    
    enum LogNavBar {
        static let dailyGoalLabelText = NSLocalizedString("dailyGoalLabel_text", comment: "Daily goal label text")
        static let streakLabelText = NSLocalizedString("streakLabel_text", comment: "Streak label text")
        static let oneNote = NSLocalizedString("oneNote", comment: "One note pluralize")
        static let fewNotes = NSLocalizedString("fewNotes", comment: "Few notes pluralize")
        static let manyNotes = NSLocalizedString("manyNotes", comment: "Many notes pluralize")
        static let oneDay = NSLocalizedString("oneDay", comment: "One day pluralize")
        static let fewDays = NSLocalizedString("fewDays", comment: "Few days pluralize")
        static let manyDays = NSLocalizedString("manyDays", comment: "Many days pluralize")
    }
}
