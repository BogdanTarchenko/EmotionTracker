import UserNotifications
import UIKit

protocol NotificationServiceProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func scheduleNotification(at time: Date, repeats: Bool)
    func removeAllNotifications()
    func isNotificationsEnabled(completion: @escaping (Bool) -> Void)
    func removeNotification(for timeString: String)
}

final class NotificationService: NotificationServiceProtocol {
    static let shared = NotificationService()
    
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func scheduleNotification(at time: Date, repeats: Bool) {
        let content = UNMutableNotificationContent()
        content.title = "Время записать эмоцию"
        content.body = "Не забудьте отметить, как вы себя чувствуете сегодня"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        
        let request = UNNotificationRequest(
            identifier: "dailyReminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка при создании уведомления: \(error)")
            }
        }
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func isNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    func removeNotification(for timeString: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [timeString])
    }
}
