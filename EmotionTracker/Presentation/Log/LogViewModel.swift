//
//  LogViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 05.03.2025.
//

import UIKit

final class LogViewModel {
    private(set) var emotionSections: [EmotionSection] = []
    var emotionCards: [EmotionCardViewModel] {
        return emotionSections.flatMap { $0.cards }
    }
    
    private var userDefaultsService: UserDefaultsServiceProtocol
    
    init(userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService()) {
        self.userDefaultsService = userDefaultsService
        addTestCards()
    }
}

extension LogViewModel {
    var dailyGoal: Int {
        get { userDefaultsService.dailyGoal }
        set { userDefaultsService.dailyGoal = newValue }
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
        
        return userDefaultsService.currentStreak
    }
    
    func checkAndUpdateStreak() {
        userDefaultsService.lastRecordDate = dateToString(Date())
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
        let dayKey = Constants.todayString
        
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
        return userDefaultsService.lastRecordDate == dateString
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
            if let commaIndex = lowercasedTime.firstIndex(of: ",") {
                return String(lowercasedTime[..<commaIndex])
            }
            return lowercasedTime
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
        let totalCount = CGFloat(todayCards.count)
        
        var colorCounts: [EmotionColor: Int] = [:]
        
        todayCards.forEach { card in
            colorCounts[card.emotionColor, default: 0] += 1
        }
        
        return colorCounts.map { color, count in
            (color: color.toUIColor(), percentage: CGFloat(count) / totalCount)
        }
    }
}

// MARK: - Test Cards

private extension LogViewModel {
    func addTestCards() {
        userDefaultsService.currentStreak = 0
        userDefaultsService.lastRecordDate = nil
        
        let yesterdayCard1 = EmotionCardViewModel(
            time: "вчера, 18:45",
            emotion: "Спокойствие",
            emotionColor: .green,
            icon: getEmotionIcon(for: .green),
            selectedTags: ["Дом", "Один"],
            tagsBySection: [
                [],
                [("Один", 0)],
                [("Дом", 0)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 1, tag: "Один"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Дом")
            ]
        )
        
        let yesterdayCard2 = EmotionCardViewModel(
            time: "вчера, 10:15",
            emotion: "Интерес",
            emotionColor: .blue,
            icon: getEmotionIcon(for: .blue),
            selectedTags: ["Встреча", "Работа"],
            tagsBySection: [
                [],
                [("Работа", 2)],
                [("Встреча", 4)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 1, tag: "Работа"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Встреча")
            ]
        )
        
        let twoDaysAgoCard1 = EmotionCardViewModel(
            time: "2 дня назад, 13:20",
            emotion: "Радость",
            emotionColor: .yellow,
            icon: getEmotionIcon(for: .yellow),
            selectedTags: ["Друзья", "Праздник"],
            tagsBySection: [
                [("Праздник", 1)],
                [("Друзья", 0)],
                []
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 0, tag: "Праздник"),
                EditNoteViewModel.SectionTag(section: 1, tag: "Друзья")
            ]
        )
        
        let twoDaysAgoCard2 = EmotionCardViewModel(
            time: "2 дня назад, 19:45",
            emotion: "Гордость",
            emotionColor: .green,
            icon: getEmotionIcon(for: .green),
            selectedTags: ["Достижение", "Спорт"],
            tagsBySection: [
                [("Достижение", 3)],
                [],
                [("Спорт", 2)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 0, tag: "Достижение"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Спорт")
            ]
        )
        
        let threeDaysAgoCard1 = EmotionCardViewModel(
            time: "3 дня назад, 10:15",
            emotion: "Усталость",
            emotionColor: .blue,
            icon: getEmotionIcon(for: .blue),
            selectedTags: ["Работа", "Стресс"],
            tagsBySection: [
                [],
                [("Работа", 2)],
                [("Стресс", 1)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 1, tag: "Работа"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Стресс")
            ]
        )
        
        let threeDaysAgoCard2 = EmotionCardViewModel(
            time: "3 дня назад, 16:30",
            emotion: "Облегчение",
            emotionColor: .green,
            icon: getEmotionIcon(for: .green),
            selectedTags: ["Отдых", "Природа"],
            tagsBySection: [
                [("Отдых", 0)],
                [],
                [("Природа", 5)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 0, tag: "Отдых"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Природа")
            ]
        )
        
        let fourDaysAgoCard1 = EmotionCardViewModel(
            time: "4 дня назад, 19:30",
            emotion: "Вдохновение",
            emotionColor: .yellow,
            icon: getEmotionIcon(for: .yellow),
            selectedTags: ["Хобби", "Творчество"],
            tagsBySection: [
                [("Творчество", 2)],
                [],
                [("Хобби", 3)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 0, tag: "Творчество"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Хобби")
            ]
        )
        
        let fourDaysAgoCard2 = EmotionCardViewModel(
            time: "4 дня назад, 09:15",
            emotion: "Бодрость",
            emotionColor: .blue,
            icon: getEmotionIcon(for: .blue),
            selectedTags: ["Утро", "Кофе"],
            tagsBySection: [
                [],
                [("Утро", 5)],
                [("Кофе", 6)]
            ],
            selectedSectionTags: [
                EditNoteViewModel.SectionTag(section: 1, tag: "Утро"),
                EditNoteViewModel.SectionTag(section: 2, tag: "Кофе")
            ]
        )
        
        let tempCards = [
            yesterdayCard1, yesterdayCard2,
            twoDaysAgoCard1, twoDaysAgoCard2,
            threeDaysAgoCard1, threeDaysAgoCard2,
            fourDaysAgoCard1, fourDaysAgoCard2
        ]
        
        var groupedCards: [String: [EmotionCardViewModel]] = [:]
        for card in tempCards {
            let dayKey = getDayKeyFromTimeString(card.time)
            if groupedCards[dayKey] == nil {
                groupedCards[dayKey] = []
            }
            groupedCards[dayKey]?.append(card)
        }
        
        emotionSections = groupedCards.map { EmotionSection(dayKey: $0.key, cards: $0.value) }
        
        emotionSections.sort { section1, section2 in
            if section1.dayKey == Constants.todayString { return true }
            if section2.dayKey == Constants.todayString { return false }
            if section1.dayKey == Constants.yesterdayString { return true }
            if section2.dayKey == Constants.yesterdayString { return false }
            
            func getDaysAgo(from key: String) -> Int {
                let components = key.components(separatedBy: " ")
                if components.count >= 1, let days = Int(components[0]) {
                    return days
                }
                return 999
            }
            
            return getDaysAgo(from: section1.dayKey) < getDaysAgo(from: section2.dayKey)
        }
        
        for sectionIndex in 0..<emotionSections.count {
            emotionSections[sectionIndex].cards.sort { card1, card2 in
                let time1 = getTimeFromTimeString(card1.time) ?? "00:00"
                let time2 = getTimeFromTimeString(card2.time) ?? "00:00"
                return time1 > time2
            }
        }
        
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        userDefaultsService.lastRecordDate = dateToString(yesterday)
        
        userDefaultsService.currentStreak = 4
    }
}

// MARK: - Constants

private extension LogViewModel {
    enum Constants {
        static let todayString = LocalizedKey.Log.todayString
        static let yesterdayString = LocalizedKey.Log.yesterdayString
    }
}
