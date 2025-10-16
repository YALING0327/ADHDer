//
//  AppDelegate-Notifications.swift
//  Adhder
//
//  Created by Phillip Thelen on 10.03.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import UIKit
import UserNotifications
import Adhder_Models
import FirebaseMessaging

extension AdhderAppDelegate: UNUserNotificationCenterDelegate {
    
    func configureNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, _) in
            if !accepted {
                logger.log("Notification access denied.")
            } else {
                DispatchQueue.main.async {
                    self.application?.registerForRemoteNotifications()
                }
            }
        }

        notificationCenter.delegate = self
        
        let completeAction = UNNotificationAction(identifier: "completeAction", title: L10n.complete, options: [])
        let taskCompleteCategory = UNNotificationCategory(identifier: "taskCompletion", actions: [completeAction], intentIdentifiers: [], options: [])
        
        let acceptAction = UNNotificationAction(identifier: "acceptAction", title: L10n.accept, options: [])
        let declineAction = UNNotificationAction(identifier: "declineAction", title: L10n.decline, options: [])
        let questInviteCategory = UNNotificationCategory(identifier: "questInvitation",
              actions: [acceptAction, declineAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: [])
        
        let replyAction = UNTextInputNotificationAction(identifier: "replyAction", title: "Reply", options: [])
        let privateMessageCategory = UNNotificationCategory(identifier: "newPM",
              actions: [replyAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: [])
        notificationCenter.setNotificationCategories([taskCompleteCategory, questInviteCategory, privateMessageCategory])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        switch response.actionIdentifier {
        case "acceptAction":
            acceptQuestInvitation { _ in
                completionHandler()
            }
        case "rejectAction":
            rejectQuestInvitation { _ in
                completionHandler()
            }
        case "replyAction":
            let userID = response.notification.request.content.userInfo["userID"] as? String
            let textResponse = response as? UNTextInputNotificationResponse
            let message = textResponse?.userText
            sendPrivateMessage(toUserID: userID ?? "", message: message ?? "") { _ in
                completionHandler()
            }
        case "completeAction":
            let taskID = response.notification.request.content.userInfo["taskID"] as? String
            scoreTask(taskID ?? "", direction: .up) {
                completionHandler()
            }
        default:
            handlePushnotification(identifier: response.notification.request.identifier, userInfo: response.notification.request.content.userInfo)
        }
    }
    
    func handlePushnotification(identifier: String?, userInfo: [AnyHashable: Any]) {
        if let sendToAnalytics = userInfo["sendAnalytics"] as? Bool, sendToAnalytics {
            AdhderAnalytics.shared.log("open notification", withEventProperties: [
                                            "identifier": identifier ?? ""])
        }
        let aps = userInfo["aps"] as? [AnyHashable: Any]
        let alert = aps?["alert"] as? [AnyHashable: Any]
        if let url = (userInfo["openURL"] as? String) ?? (aps?["openURL"] as? String) ?? (alert?["openURL"] as? String) {
            RouterHandler.shared.handle(urlString: url)
        } else if let identifier = identifier ?? userInfo["identifier"] as? String ?? aps?["identifier"] as? String {
            if ["newPM", "giftedGems", "giftedSubscription"].contains(identifier) {
                RouterHandler.shared.handle(urlString: "/")
            } else if ["invitedParty", "questStarted", "invitedQuest"].contains(identifier) {
                RouterHandler.shared.handle(urlString: "/party")
            } else if ["groupActivity", "chatMention"].contains(identifier) {
                if userInfo["type"] as? String == "party" {
                    RouterHandler.shared.handle(urlString: "/party")
                } else {
                    RouterHandler.shared.handle(urlString: "/groups/guild/\(userInfo["groupID"] as? String ?? "")")
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let taskID = notification.request.content.userInfo["taskID"] as? String {
            let alert = AdhderAlertController(title: notification.request.content.title, message: notification.request.content.body)
            alert.addAction(title: L10n.complete, isMainAction: true) {[weak self] _ in
                self?.scoreTask(taskID, direction: .up) {}
            }
            alert.addCloseAction()
            alert.show()
        }
        completionHandler([])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        saveDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        displayNotificationInApp(title: userInfo["title"] as? String ?? "", text: userInfo["body"] as? String ?? "")
        completionHandler(.newData)
    }
    
    func rescheduleDailyReminder() {
        let defaults = UserDefaults.standard
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: (0...7).map({ number in
            return "dailyReminderNotification\(number)"
        }))
        
        if defaults.bool(forKey: "dailyReminderActive"), let reminderTime = defaults.value(forKey: "dailyReminderTime") as? Date {
            let calendar = Calendar(identifier: .gregorian)
            let now = Date()
            
            let timeComponents = calendar.dateComponents([.hour, .minute], from: reminderTime)
            
            var todayComponents = calendar.dateComponents([.year, .month, .day], from: now)
            todayComponents.hour = timeComponents.hour
            todayComponents.minute = timeComponents.minute
            todayComponents.second = 0
            
            var actualDate = calendar.date(from: todayComponents) ?? now
            
            if actualDate <= now {
                actualDate = calendar.date(byAdding: .day, value: 1, to: actualDate) ?? actualDate
            }
            
            var offsetter = DateComponents()
            offsetter.day = 1
            
            for offset in 0...6 {
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: actualDate)
                let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
                let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)

                let notification = buildBaseNotification()
                notification.title = L10n.rememberCheckOffDailies
                notification.body = randomDailyTip()
                let request = UNNotificationRequest(identifier: "dailyReminderNotification\(offset)", content: notification, trigger: trigger)
                UNUserNotificationCenter.current().add(request) {(error) in
                    if let error = error {
                        logger.log("Uh oh! We had an error: \(error)")
                    }
                }
                actualDate = calendar.date(byAdding: offsetter, to: actualDate) ?? Date()
            }
            
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: actualDate)
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)

            let notification = buildBaseNotification()
            notification.title = L10n.weekReminderTitle
            notification.body = L10n.weekReminderBody
            let request = UNNotificationRequest(identifier: "dailyReminderNotification7", content: notification, trigger: trigger)
            UNUserNotificationCenter.current().add(request) {(error) in
                if let error = error {
                    logger.log("Uh oh! We had an error: \(error)")
                }
            }
        }
    }
    
    private func randomDailyTip() -> String {
        return [
            L10n.dailyTip0,
            L10n.dailyTip1,
            L10n.dailyTip2,
            L10n.dailyTip3,
            L10n.dailyTip4,
            L10n.dailyTip5,
            L10n.dailyTip6,
            L10n.dailyTip7,
            L10n.dailyTip8,
            L10n.dailyTip9
        ].randomElement() ?? ""
    }
    
    private func buildBaseNotification() -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.sound = UNNotificationSound.default
        return notification
    }
    
}
