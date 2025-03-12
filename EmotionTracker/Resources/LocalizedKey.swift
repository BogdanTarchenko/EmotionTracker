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
        static let alertTitle = NSLocalizedString("alert_log_title", comment: "Log screen alert title")
        static let alertMessage = NSLocalizedString("alert_log_message", comment: "Log screen alert message")
        static let alertCancel = NSLocalizedString("alert_log_cancel", comment: "Log screen alert cancel")
        static let todayString = NSLocalizedString("today_string", comment:"Today string")
        static let yesterdayString = NSLocalizedString("yesterday_string", comment: "Yesterday string")
    }
    
    enum TabBar {
        static let logTabBarItemTitle = NSLocalizedString("logTabBarItem_title", comment: "Log tab bar item title")
        static let statisticsTabBarItemTitle = NSLocalizedString("statisticsTabBarItem_title", comment: "Statistics tab bar item title")
        static let settingsTabBarItemTitle = NSLocalizedString("settingsTabBarItem_title", comment: "Settings tab bar item title")
    }
    
    enum Settings {
        static let settingsTitle = NSLocalizedString("settings_title", comment: "Settings screen title")
        static let defaultProfileFullNameLabelText = NSLocalizedString("defaultProfileFullNameLabel_text", comment: "Default profile full name label text")
        static let alertTitle = NSLocalizedString("alert_title", comment: "Alert settings switcher title")
        static let addAlertText = NSLocalizedString("addAlert_text", comment: "Add alert text")
        static let faceIDTitle = NSLocalizedString("faceID_title", comment: "Face ID settings switcher title")
    }
    
    enum Statistics {
        static let firstVCTitle = NSLocalizedString("firstVC_title", comment: "first VC title")
        static let secondVCTitle = NSLocalizedString("secondVC_title", comment: "second VC title")
        static let thirdVCTitle = NSLocalizedString("thirdVC_title", comment: "third VC title")
        static let fourthVCTitle = NSLocalizedString("fourthVC_title", comment: "fourth VC title")
    }
    
    enum EditNote {
        static let navigationBarTitle = NSLocalizedString("editNoteNavigation_title", comment: "EditNote screen navigation title")
        static let saveNoteButtonTitle = NSLocalizedString("saveNoteButton_title", comment: "Save note button title")
        static let duplicatedTagsAlertMessage = NSLocalizedString("duplicatedTagsAlert_message", comment: "Duplicated tags alert message")
        static let duplicatedTagsAlertTitle = NSLocalizedString("duplicatedTagsAlert_title", comment: "Duplicated tags alert title")
    }
    
    enum AddNote {
        static let pickEmotionTitle = NSLocalizedString("pickEmotion_title", comment: "Pick emotion title")
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
    
    enum AlertTimePicker {
        static let pickTimeText = NSLocalizedString("pickTime_text", comment: "Pick time text")
        static let cancelButtonText = NSLocalizedString("cancelButton_text", comment: "Cancel button text")
        static let pickButtonText = NSLocalizedString("pickButton_text", comment: "Pick button text")
    }
}
