//
//  LocalNotificationsManager.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 03.05.2023.
//

import UserNotifications

final class LocalNotificationsManager {
    enum TriggerEvents {
        case HKNoShareRights
    }
    
    static private let center = UNUserNotificationCenter.current()
    
    static func performUserNotification(for event: TriggerEvents) {
        switch event {
        case .HKNoShareRights:
            scheduleHKNoShareRightsNotification()
        }
    }
    
    static func askPermission() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static private func scheduleHKNoShareRightsNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Check permissions"
        content.subtitle = "Please check your Health permissions"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        // add our notification request
        center.add(request)
    }
}
