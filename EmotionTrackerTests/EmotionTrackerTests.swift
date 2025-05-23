import XCTest
@testable import EmotionTracker

final class EmotionTrackerTests: XCTestCase {
    
    var coreDataService: CoreDataServiceProtocol!
    var notificationService: MockNotificationService!
    var settingsViewModel: SettingsViewModel!
    
    override func setUp() {
        super.setUp()
        coreDataService = MockCoreDataService()
        notificationService = MockNotificationService()
        settingsViewModel = SettingsViewModel(
            notificationService: notificationService,
            coreDataService: coreDataService
        )
        
        (coreDataService as? MockCoreDataService)?.clearAll()
        notificationService.scheduledNotifications.removeAll()
    }
    
    override func tearDown() {
        coreDataService = nil
        notificationService = nil
        settingsViewModel = nil
        super.tearDown()
    }
    
    // MARK: - Notification Tests
    
    func testAddNotification() {
        // Given
        let time = "09:00"
        
        // When
        settingsViewModel.addAlertTime(time)
        
        // Then
        XCTAssertEqual(settingsViewModel.alertTimes.count, 1)
        XCTAssertEqual(settingsViewModel.alertTimes.first, time)
        XCTAssertEqual(coreDataService.alertTimes.count, 1)
        XCTAssertEqual(coreDataService.alertTimes.first, time)
    }
    
    func testRemoveNotification() {
        // Given
        let time = "09:00"
        settingsViewModel.addAlertTime(time)
        
        // When
        settingsViewModel.removeAlertTime(at: 0)
        
        // Then
        XCTAssertEqual(settingsViewModel.alertTimes.count, 0)
        XCTAssertEqual(coreDataService.alertTimes.count, 0)
    }
    
    func testMultipleNotifications() {
        // Given
        let times = ["09:00", "12:00", "18:00"]
        
        // When
        times.forEach { settingsViewModel.addAlertTime($0) }
        
        // Then
        XCTAssertEqual(settingsViewModel.alertTimes.count, 3)
        XCTAssertEqual(settingsViewModel.alertTimes, times)
        XCTAssertEqual(coreDataService.alertTimes.count, 3)
        XCTAssertEqual(coreDataService.alertTimes, times)
    }
    
    func testNotificationSettingsPersistence() {
        // Given
        let time = "09:00"
        settingsViewModel.addAlertTime(time)
        settingsViewModel.toggleNotifications(true)
        
        // Then
        XCTAssertEqual(coreDataService.alertTimes.count, 1)
        XCTAssertEqual(coreDataService.alertTimes.first, time)
        
        // When
        let newViewModel = SettingsViewModel(
            notificationService: notificationService,
            coreDataService: coreDataService
        )
        
        // Then
        XCTAssertEqual(newViewModel.alertTimes.count, 1)
        XCTAssertEqual(newViewModel.alertTimes.first, time)
    }
    
    // MARK: - Log Tests
    
    func testTodayRecordsCount() {
        // Given
        let logViewModel = LogViewModel(coreDataService: coreDataService)
        
        // When
        logViewModel.addNewEmotionCard(
            emotion: "Счастье",
            emotionColor: .blue,
            selectedTags: ["Работа"]
        )
        logViewModel.addNewEmotionCard(
            emotion: "Грусть",
            emotionColor: .red,
            selectedTags: ["Дом"]
        )
        
        // Then
        XCTAssertEqual(logViewModel.getTodayRecordsCount(), 2)
        XCTAssertTrue(logViewModel.hasTodayRecords())
    }
    
    func testDailyProgress() {
        // Given
        let logViewModel = LogViewModel(coreDataService: coreDataService)
        logViewModel.dailyGoal = 3
        
        // When
        logViewModel.addNewEmotionCard(
            emotion: "Счастье",
            emotionColor: .blue,
            selectedTags: ["Работа"]
        )
        logViewModel.addNewEmotionCard(
            emotion: "Грусть",
            emotionColor: .red,
            selectedTags: ["Дом"]
        )
        
        // Then
        XCTAssertEqual(logViewModel.getDailyProgress(), 2.0/3.0)
    }
    
    func testNoRecordsToday() {
        // Given
        let logViewModel = LogViewModel(coreDataService: coreDataService)
        
        // Then
        XCTAssertEqual(logViewModel.getTodayRecordsCount(), 0)
        XCTAssertFalse(logViewModel.hasTodayRecords())
        XCTAssertEqual(logViewModel.getDailyProgress(), 0)
    }
    
    func testDailyProgressExceedsGoal() {
        // Given
        let logViewModel = LogViewModel(coreDataService: coreDataService)
        logViewModel.dailyGoal = 2
        
        // When
        logViewModel.addNewEmotionCard(
            emotion: "Счастье",
            emotionColor: .blue,
            selectedTags: ["Работа"]
        )
        logViewModel.addNewEmotionCard(
            emotion: "Грусть",
            emotionColor: .red,
            selectedTags: ["Дом"]
        )
        logViewModel.addNewEmotionCard(
            emotion: "Радость",
            emotionColor: .green,
            selectedTags: ["Отдых"]
        )
        
        // Then
        XCTAssertEqual(logViewModel.getDailyProgress(), 1.0)
    }
    
    // MARK: - AddNote Tests
    
    func testEmotionSelection() {
        // Given
        let viewModel = AddNoteViewModel()
        let expectation = XCTestExpectation(description: "Emotion picker state changed")
        
        // When
        viewModel.onEmotionPickerStateChanged = { state in
            // Then
            switch state {
            case .active(let emotionTitle, let emotionDescription, let emotionColor):
                XCTAssertEqual(emotionTitle, "Счастье")
                XCTAssertEqual(emotionDescription, "Описание эмоции: Счастье")
                XCTAssertEqual(emotionColor, .yellowPrimary)
            case .inactive:
                XCTFail("State should be active")
            }
            expectation.fulfill()
        }
        
        viewModel.selectEmotion(emotion: ("Счастье", .yellowPrimary))
        
        // Then
        XCTAssertEqual(viewModel.selectedEmotion?.title, "Счастье")
        XCTAssertEqual(viewModel.selectedEmotion?.color, .yellowPrimary)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testEmotionList() {
        // Given
        let viewModel = AddNoteViewModel()
        
        // Then
        XCTAssertEqual(viewModel.emotions.count, 16)
        
        let redEmotions = viewModel.emotions.filter { $0.color == .redPrimary }
        XCTAssertEqual(redEmotions.count, 4)
        XCTAssertTrue(redEmotions.contains { $0.title == "Ярость" })
        XCTAssertTrue(redEmotions.contains { $0.title == "Напряжение" })
        XCTAssertTrue(redEmotions.contains { $0.title == "Зависть" })
        XCTAssertTrue(redEmotions.contains { $0.title == "Беспокойство" })
        
        let yellowEmotions = viewModel.emotions.filter { $0.color == .yellowPrimary }
        XCTAssertEqual(yellowEmotions.count, 4)
        XCTAssertTrue(yellowEmotions.contains { $0.title == "Возбуждение" })
        XCTAssertTrue(yellowEmotions.contains { $0.title == "Восторг" })
        XCTAssertTrue(yellowEmotions.contains { $0.title == "Уверенность" })
        XCTAssertTrue(yellowEmotions.contains { $0.title == "Счастье" })
        
        let blueEmotions = viewModel.emotions.filter { $0.color == .bluePrimary }
        XCTAssertEqual(blueEmotions.count, 4)
        XCTAssertTrue(blueEmotions.contains { $0.title == "Выгорание" })
        XCTAssertTrue(blueEmotions.contains { $0.title == "Усталость" })
        XCTAssertTrue(blueEmotions.contains { $0.title == "Депрессия" })
        XCTAssertTrue(blueEmotions.contains { $0.title == "Апатия" })
        
        let greenEmotions = viewModel.emotions.filter { $0.color == .greenPrimary }
        XCTAssertEqual(greenEmotions.count, 4)
        XCTAssertTrue(greenEmotions.contains { $0.title == "Спокойствие" })
        XCTAssertTrue(greenEmotions.contains { $0.title == "Удовлетворённость" })
        XCTAssertTrue(greenEmotions.contains { $0.title == "Благодарность" })
        XCTAssertTrue(greenEmotions.contains { $0.title == "Защищённость" })
    }
    
    func testEmotionSelectionMultipleTimes() {
        // Given
        let viewModel = AddNoteViewModel()
        let expectation = XCTestExpectation(description: "Emotion picker state changed")
        var selectionCount = 0
        
        // When
        viewModel.onEmotionPickerStateChanged = { state in
            switch state {
            case .active(let emotionTitle, _, _):
                if selectionCount == 0 {
                    XCTAssertEqual(emotionTitle, "Счастье")
                } else {
                    XCTAssertEqual(emotionTitle, "Грусть")
                }
                selectionCount += 1
                if selectionCount == 2 {
                    expectation.fulfill()
                }
            case .inactive:
                XCTFail("State should be active")
            }
        }
        
        // Then
        viewModel.selectEmotion(emotion: ("Счастье", .yellowPrimary))
        viewModel.selectEmotion(emotion: ("Грусть", .bluePrimary))
        
        XCTAssertEqual(viewModel.selectedEmotion?.title, "Грусть")
        XCTAssertEqual(viewModel.selectedEmotion?.color, .bluePrimary)
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Emotion Record Creation Tests
    
    func testCreateEmotionRecord() {
        // Given
        let logViewModel = LogViewModel(coreDataService: coreDataService)
        let addNoteViewModel = AddNoteViewModel()
        
        // When
        addNoteViewModel.selectEmotion(emotion: ("Счастье", .yellowPrimary))
        logViewModel.addNewEmotionCard(
            emotion: addNoteViewModel.selectedEmotion?.title ?? "",
            emotionColor: .yellow,
            selectedTags: ["Работа", "Успех"]
        )
        
        // Then
        XCTAssertEqual(logViewModel.getTodayRecordsCount(), 1)
        let records = coreDataService.fetchEmotionRecords()
        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records.first?.emotion, "Счастье")
        XCTAssertEqual(Set(records.first?.tags ?? []), Set(["Работа", "Успех"]))
    }
    
    func testCreateEmotionRecordWithCustomTags() {
        // Given
        let logViewModel = LogViewModel(coreDataService: coreDataService)
        let addNoteViewModel = AddNoteViewModel()
        let customTags = ["Новый тег 1", "Новый тег 2"]
        
        // When
        addNoteViewModel.selectEmotion(emotion: ("Грусть", .bluePrimary))
        logViewModel.addNewEmotionCard(
            emotion: addNoteViewModel.selectedEmotion?.title ?? "",
            emotionColor: .blue,
            selectedTags: Set(customTags)
        )
        
        // Then
        let records = coreDataService.fetchEmotionRecords()
        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records.first?.emotion, "Грусть")
        XCTAssertEqual(Set(records.first?.tags ?? []), Set(customTags))
    }
}

// MARK: - Mock Services

class MockCoreDataService: CoreDataServiceProtocol {
    private var _alertTimes: [String] = []
    private var _isNotificationsEnabled: Bool = false
    private var _emotionRecords: [EmotionRecord] = []
    
    var alertTimes: [String] {
        get { _alertTimes }
        set { _alertTimes = newValue }
    }
    
    var isNotificationsEnabled: Bool {
        get { _isNotificationsEnabled }
        set { _isNotificationsEnabled = newValue }
    }
    
    var dailyGoal: Int = 3
    var lastRecordDate: String?
    var currentStreak: Int = 0
    var isBiometricEnabled: Bool = false
    
    func saveEmotionRecord(emotion: String, note: String?, tags: [String]?, color: String?) {
        let record = EmotionRecord(context: CoreDataManager.shared.context)
        record.date = Date()
        record.emotion = emotion
        record.note = note
        record.tags = tags
        record.color = color
        _emotionRecords.append(record)
    }
    
    func fetchEmotionRecords() -> [EmotionRecord] {
        return _emotionRecords
    }
    
    func deleteEmotionRecord(_ record: EmotionRecord) {}
    func updateEmotionRecord(_ record: EmotionRecord, emotion: String, note: String?, tags: [String]?, color: String?) {}
    
    func clearAll() {
        _alertTimes.removeAll()
        _isNotificationsEnabled = false
        _emotionRecords.removeAll()
    }
}

class MockNotificationService: NotificationServiceProtocol {
    var isAuthorized: Bool = false
    var scheduledNotifications: [String] = []
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        isAuthorized = true
        completion(true)
    }
    
    func scheduleNotification(at time: Date, repeats: Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: time)
        scheduledNotifications.append(timeString)
    }
    
    func removeAllNotifications() {
        scheduledNotifications.removeAll()
    }
    
    func isNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        completion(isAuthorized)
    }
    
    func removeNotification(for timeString: String) {
        scheduledNotifications.removeAll { $0 == timeString }
    }
}
