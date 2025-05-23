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
}

// MARK: - Mock Services

class MockCoreDataService: CoreDataServiceProtocol {
    private var _alertTimes: [String] = []
    private var _isNotificationsEnabled: Bool = false
    
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
    
    func saveEmotionRecord(emotion: String, note: String?, tags: [String]?, color: String?) {}
    func fetchEmotionRecords() -> [EmotionRecord] { return [] }
    func deleteEmotionRecord(_ record: EmotionRecord) {}
    func updateEmotionRecord(_ record: EmotionRecord, emotion: String, note: String?, tags: [String]?, color: String?) {}
    
    func clearAll() {
        _alertTimes.removeAll()
        _isNotificationsEnabled = false
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
