//
//  LogViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 05.03.2025.
//

import UIKit
import CoreData

final class LogViewModel {
    private(set) var emotionSections: [EmotionSection] = []
    var emotionCards: [EmotionCardViewModel] {
        return emotionSections.flatMap { $0.cards }
    }
    
    private var coreDataService: CoreDataServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol = CoreDataService()) {
        self.coreDataService = coreDataService
        loadEmotionRecords()
    }
    
    private func loadEmotionRecords() {
        let records = coreDataService.fetchEmotionRecords()
        for record in records {
            let card = createEmotionCard(
                time: record.date?.formattedRelativeTime() ?? "",
                emotion: record.emotion ?? "",
                emotionColor: EmotionColor(rawValue: record.color ?? "") ?? .blue,
                selectedTags: Set(record.tags ?? []),
                tagsBySection: [[], [], []],
                selectedSectionTags: []
            )
            addCardToSections(card)
        }
    }
}

extension LogViewModel {
    var dailyGoal: Int {
        get { coreDataService.dailyGoal }
        set { coreDataService.dailyGoal = newValue }
    }
    
    func hasTodayRecords() -> Bool {
        return getTodayRecordsCount() > 0
    }
    
    func getEmotionData(at index: Int) -> EmotionCardViewModel? {
        var globalIndex = 0
        
        for section in emotionSections {
            if globalIndex + section.cards.count > index {
                return section.cards[index - globalIndex]
            }
            globalIndex += section.cards.count
        }
        return nil
    }
}

// MARK: - Emotion Cards Management

extension LogViewModel {
    func addNewEmotionCard(emotion: String, 
                           emotionColor: EmotionColor, 
                           selectedTags: Set<String>,
                           tagsBySection: [[(tag: String, index: Int)]] = [[], [], []],
                           selectedSectionTags: Set<EditNoteViewModel.SectionTag> = []) {
        let newCard = createEmotionCard(
            time: getCurrentFormattedTime(),
            emotion: emotion,
            emotionColor: emotionColor,
            selectedTags: selectedTags,
            tagsBySection: tagsBySection,
            selectedSectionTags: selectedSectionTags
        )
        
        addCardToSections(newCard)
        coreDataService.saveEmotionRecord(
            emotion: emotion,
            note: nil,
            tags: Array(selectedTags),
            color: emotionColor.rawValue
        )
        checkAndUpdateStreak()
    }
    
    func updateEmotionCard(at index: Int,
                           title: String,
                           color: EmotionColor,
                           selectedTags: Set<String>,
                           tagsBySection: [[(tag: String, index: Int)]] = [[], [], []],
                           selectedSectionTags: Set<EditNoteViewModel.SectionTag> = []) {
        guard let currentCard = findCard(at: index) else { return }
        
        let updatedCard = createEmotionCard(
            time: currentCard.time,
            emotion: title,
            emotionColor: color,
            selectedTags: selectedTags,
            tagsBySection: tagsBySection,
            selectedSectionTags: selectedSectionTags
        )
        
        updateCardInSections(updatedCard, at: index)
        
        if let record = findEmotionRecord(for: currentCard) {
            coreDataService.updateEmotionRecord(
                record,
                emotion: title,
                note: nil,
                tags: Array(selectedTags),
                color: color.rawValue
            )
        }
    }
}

// MARK: - Statistics

extension LogViewModel {
    func getTodayRecordsCount() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return emotionCards.filter { card in
            let timeString = card.time.lowercased()
            
            if timeString.starts(with: Constants.todayString) {
                return true
            } else if timeString.starts(with: Constants.yesterdayString) {
                return false
            } else {
                if let cardDate = dateFromRelativeString(card.time) {
                    return calendar.isDate(cardDate, inSameDayAs: today)
                }
                return false
            }
        }.count
    }
    
    func getDailyProgress() -> CGFloat {
        let todayCount = getTodayRecordsCount()
        return min(CGFloat(todayCount) / CGFloat(dailyGoal), 1.0)
    }
    
    func getCurrentStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        let todayCount = getTodayRecordsCount()
        let hasYesterdayRecord = hasRecordForDate(yesterday)
        
        if todayCount == 0 && !hasYesterdayRecord {
            return 0
        }
        
        return coreDataService.currentStreak
    }
    
    func checkAndUpdateStreak() {
        coreDataService.lastRecordDate = dateToString(Date())
    }
}

// MARK: - Private Helpers

private extension LogViewModel {
    func createEmotionCard(time: String,
                           emotion: String,
                           emotionColor: EmotionColor,
                           selectedTags: Set<String>,
                           tagsBySection: [[(tag: String, index: Int)]],
                           selectedSectionTags: Set<EditNoteViewModel.SectionTag>) -> EmotionCardViewModel {
        return EmotionCardViewModel(
            time: time,
            emotion: emotion,
            emotionColor: emotionColor,
            icon: getEmotionIcon(for: emotionColor),
            selectedTags: selectedTags,
            tagsBySection: tagsBySection,
            selectedSectionTags: selectedSectionTags
        )
    }
    
    func addCardToSections(_ card: EmotionCardViewModel) {
        let dayKey = getDayKeyFromTimeString(card.time)
        
        if let index = emotionSections.firstIndex(where: { $0.dayKey == dayKey }) {
            emotionSections[index].cards.insert(card, at: 0)
        } else {
            let newSection = EmotionSection(dayKey: dayKey, cards: [card])
            emotionSections.insert(newSection, at: 0)
        }
    }
    
    func findCard(at index: Int) -> EmotionCardViewModel? {
        var globalIndex = 0
        
        for section in emotionSections {
            if globalIndex + section.cards.count > index {
                return section.cards[index - globalIndex]
            }
            globalIndex += section.cards.count
        }
        return nil
    }
    
    func updateCardInSections(_ card: EmotionCardViewModel, at index: Int) {
        var globalIndex = 0
        
        for (sectionIndex, section) in emotionSections.enumerated() {
            if globalIndex + section.cards.count > index {
                let cardIndex = index - globalIndex
                emotionSections[sectionIndex].cards[cardIndex] = card
                break
            }
            globalIndex += section.cards.count
        }
    }
    
    func getTodayCards() -> [EmotionCardViewModel] {
        return emotionCards.filter { card in
            card.time.lowercased().starts(with: Constants.todayString)
        }
    }
    
    func getEmotionIcon(for emotionColor: EmotionColor) -> UIImage? {
        switch emotionColor {
        case .blue:
            return UIImage(named: "TestEmotionBlueImg")
        case .green:
            return UIImage(named: "TestEmotionGreenImg")
        case .yellow:
            return UIImage(named: "TestEmotionYellowImg")
        case .red:
            return UIImage(named: "TestEmotionRedImg")
        }
    }
    
    private func findEmotionRecord(for card: EmotionCardViewModel) -> EmotionRecord? {
        let records = coreDataService.fetchEmotionRecords()
        return records.first { record in
            record.emotion == card.emotion &&
            record.date?.formattedRelativeTime() == card.time
        }
    }
}

// MARK: - Date Helpers

private extension LogViewModel {
    func getCurrentFormattedTime() -> String {
        return Date().formattedRelativeTime()
    }
    
    func dateFromRelativeString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.date(from: string)
    }
    
    func hasRecordForDate(_ date: Date) -> Bool {
        let dateString = dateToString(date)
        return coreDataService.lastRecordDate == dateString
    }
    
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func getTimeFromTimeString(_ timeString: String) -> String? {
        let components = timeString.components(separatedBy: ", ")
        if components.count >= 2 {
            return components[1]
        }
        return nil
    }
    
    func getDayKeyFromTimeString(_ timeString: String) -> String {
        let lowercasedTime = timeString.lowercased()
        
        if lowercasedTime.starts(with: Constants.todayString) {
            return Constants.todayString
        } else if lowercasedTime.starts(with: Constants.yesterdayString) {
            return Constants.yesterdayString
        } else {
            return timeString
        }
    }
}

// MARK: - Ring Methods

extension LogViewModel {
    func getRingProgress() -> CGFloat {
        let progressValue = getDailyProgress()
        return progressValue
    }
    
    func getTodayEmotionsForRing() -> [(color: UIColor, percentage: CGFloat)] {
        let todayCards = getTodayCards()
        let goal = CGFloat(dailyGoal)
        
        var colorCounts: [EmotionColor: Int] = [:]
        
        todayCards.forEach { card in
            colorCounts[card.emotionColor, default: 0] += 1
        }
        
        return colorCounts.map { color, count in
            (color: color.toUIColor(), percentage: CGFloat(count) / goal)
        }
    }
}

// MARK: - Constants

private extension LogViewModel {
    enum Constants {
        static let todayString = LocalizedKey.Log.todayString
        static let yesterdayString = LocalizedKey.Log.yesterdayString
    }
}
