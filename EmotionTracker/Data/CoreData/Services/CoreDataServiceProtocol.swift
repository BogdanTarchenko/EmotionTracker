import CoreData
import Foundation

protocol CoreDataServiceProtocol {
    var dailyGoal: Int { get set }
    var lastRecordDate: String? { get set }
    var currentStreak: Int { get set }
    var isNotificationsEnabled: Bool { get set }
    var alertTimes: [String] { get set }
    var isBiometricEnabled: Bool { get set }
    
    func saveEmotionRecord(emotion: String, note: String?, tags: [String]?, color: String?)
    func fetchEmotionRecords() -> [EmotionRecord]
    func deleteEmotionRecord(_ record: EmotionRecord)
    func updateEmotionRecord(_ record: EmotionRecord, emotion: String, note: String?, tags: [String]?, color: String?)
}

final class CoreDataService: CoreDataServiceProtocol {
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - UserSettings
    
    private var userSettings: UserSettings {
        let fetchRequest: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        
        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            if let settings = results.first {
                return settings
            } else {
                let settings = UserSettings(context: coreDataManager.context)
                settings.dailyGoal = 3
                settings.currentStreak = 0
                settings.isNotificationsEnabled = false
                settings.alertTimes = []
                coreDataManager.saveContext()
                return settings
            }
        } catch {
            fatalError("\(error)")
        }
    }
    
    var dailyGoal: Int {
        get { Int(userSettings.dailyGoal) }
        set {
            userSettings.dailyGoal = Int16(newValue)
            coreDataManager.saveContext()
        }
    }
    
    var lastRecordDate: String? {
        get { userSettings.lastRecordDate }
        set {
            userSettings.lastRecordDate = newValue
            coreDataManager.saveContext()
        }
    }
    
    var currentStreak: Int {
        get { Int(userSettings.currentStreak) }
        set {
            userSettings.currentStreak = Int16(newValue)
            coreDataManager.saveContext()
        }
    }
    
    var isNotificationsEnabled: Bool {
        get { userSettings.isNotificationsEnabled }
        set {
            userSettings.isNotificationsEnabled = newValue
            coreDataManager.saveContext()
        }
    }
    
    var alertTimes: [String] {
        get { userSettings.alertTimes ?? [] }
        set {
            userSettings.alertTimes = newValue
            coreDataManager.saveContext()
        }
    }
    
    var isBiometricEnabled: Bool {
        get { userSettings.isBiometricEnabled }
        set {
            userSettings.isBiometricEnabled = newValue
            coreDataManager.saveContext()
        }
    }
    
    // MARK: - EmotionRecords
    
    func saveEmotionRecord(emotion: String, note: String?, tags: [String]?, color: String?) {
        print("Сохраняем теги:", tags ?? [])
        let record = EmotionRecord(context: coreDataManager.context)
        record.date = Date()
        record.emotion = emotion
        record.note = note
        record.tags = tags
        record.color = color
        coreDataManager.saveContext()
    }
    
    func fetchEmotionRecords() -> [EmotionRecord] {
        let fetchRequest: NSFetchRequest<EmotionRecord> = EmotionRecord.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let records = try coreDataManager.context.fetch(fetchRequest)
            return records
        } catch {
            return []
        }
    }
    
    func deleteEmotionRecord(_ record: EmotionRecord) {
        coreDataManager.context.delete(record)
        coreDataManager.saveContext()
    }
    
    func updateEmotionRecord(_ record: EmotionRecord, emotion: String, note: String?, tags: [String]?, color: String?) {
        record.emotion = emotion
        record.note = note
        record.tags = tags
        record.color = color
        coreDataManager.saveContext()
    }
}
