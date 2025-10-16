//
//  UserManager.swift
//  Adhder
//
//  Created by Phillip Thelen on 26.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift
import Adhder_Database

@objc
class UserManager: NSObject {
    
    @objc public static let shared = UserManager()
    
    private let userRepository = UserRepository()
    private let taskRepository = TaskRepository()
    private let inventoryRepository = InventoryRepository()
    private let disposable = CompositeDisposable()
    private let configRepository = ConfigRepository.shared
    
    private weak var faintViewController: FaintViewController?
    weak var classSelectionViewController: ClassSelectionViewController?
    private var lastClassSelectionDisplayed: Date?
    private var lastQuestCompletionDisplayed: Date?
    private var lastYesterdailyDialog: Date?
    weak var yesterdailiesDialog: YesterdailiesDialogView?
    
    private var tutorialSteps = [String: Bool]()
        
    private func getYesterday() -> Date? {
        let today = Date()
        return Calendar.current.date(byAdding: .day, value: -1, to: today)
    }
    
    func beginListening() {
        disposable.add(userRepository.getUser()
            .throttle(0.5, on: QueueScheduler.main)
            .on(value: {[weak self]user in
                self?.onUserUpdated(user: user)
            }).filter({[weak self] (user) -> Bool in
                return user.needsCron && self?.yesterdailiesDialog == nil
            }).flatMap(.latest, {[weak self] user in
                return self?.taskRepository.retrieveTasks(dueOnDay: self?.getYesterday()).skipNil()
                    .map({ tasks in
                        return tasks.filter({ task in
                            return task.isDue && !task.completed && !task.isGroupTask
                        })
                    }).withLatest(from: SignalProducer<UserProtocol, Never>(value: user)) ?? Signal<([TaskProtocol], UserProtocol), Never>.empty
            }).on(value: {[weak self] (tasks, user) in
                
                if UserDefaults.standard.bool(forKey: "isInSetup") && user.flags?.welcomed == false {
                    self?.userRepository.updateUser(key: "flags.welcomed", value: true).observeCompleted {
                    }
                }
                
                var uncompletedTaskCount = 0
                for task in tasks {
                    if task.type == "daily" && !task.completed {
                        uncompletedTaskCount += 1
                    }
                }
                
                if !user.needsCron {
                    return
                }
                
                self?.runCron(tasks: tasks, uncompletedTaskCount: uncompletedTaskCount)
            })
            .on(failed: { error in
                logger.log(error)
            })
            .start())
        disposable.add(taskRepository.getReminders()
            .debounce(2, on: QueueScheduler.main)
            .on(value: {[weak self](reminders, changes) in
            if let changes = changes {
                self?.updateReminderNotifications(reminders: reminders, changes: changes)
            }
        }).start())
    }
    
    private func runCron(tasks: [TaskProtocol], uncompletedTaskCount: Int) {
        if (lastYesterdailyDialog?.timeIntervalSinceNow ?? -600) > -600 {
            return
        }
        lastYesterdailyDialog = Date()
        var eventProperties = [String: Any]()
        eventProperties["eventAction"] = "show cron"
        eventProperties["eventCategory"] = "behaviour"
        eventProperties["event"] = "event"
        eventProperties["task count"] = uncompletedTaskCount
        AdhderAnalytics.shared.log("show cron", withEventProperties: eventProperties)
        
        if uncompletedTaskCount == 0 {
            userRepository.runCron(checklistItems: [], tasks: [])
            return
        }
        
        let viewController = YesterdailiesDialogView()
        viewController.tasks = tasks
        let alert = AdhderAlertController()
        alert.title = L10n.welcomeBack
        alert.message = L10n.checkinYesterdaysDalies
        alert.contentView = viewController.view
        alert.contentViewInsets = .zero
        alert.dismissOnBackgroundTap = false
        alert.maxAlertWidth = 400
        alert.addAction(title: L10n.startMyDay, style: .default, isMainAction: true, closeOnTap: true) {[weak self] _ in
            viewController.runCron()
            self?.yesterdailiesDialog = nil
        }
        yesterdailiesDialog = viewController
        alert.enqueue()
    }
    
    private func updateQuestStatus(user: UserProtocol?) {
        guard let user = user,
              user.isValid,
              let partyId = user.party?.id,
              !partyId.isEmpty,
              let quest = user.party?.quest,
              let questKey = quest.key,
              !questKey.isEmpty else {
            TaskRepository.currentUserQuestStatus = .noQuest
            TaskRepository.currentQuestKey = nil
            return
        }
        
        TaskRepository.currentQuestKey = questKey
        inventoryRepository.getQuest(key: questKey)
            .take(first: 1)
            .on(value: { questContent in
                if let questContent = questContent {
                    if questContent.isCollectionQuest {
                        TaskRepository.currentUserQuestStatus = .questCollect
                    } else if questContent.isBossQuest {
                        TaskRepository.currentUserQuestStatus = .questBoss
                    } else {
                        TaskRepository.currentUserQuestStatus = .questUnknown
                    }
                } else {
                    TaskRepository.currentUserQuestStatus = .questUnknown
                }
            })
            .start()
    }
    
    private func onUserUpdated(user: UserProtocol) {
        if !user.isValid {
            return
        }
        updateQuestStatus(user: user)
        SoundManager.shared.currentTheme = SoundTheme(rawValue: user.preferences?.sound ?? "") ?? SoundTheme.none
        
        tutorialSteps = [:]
        user.flags?.tutorials.forEach({ (tutorial) in
            if let key = tutorial.key {
                tutorialSteps[key] = tutorial.wasSeen
            }
        })
        
        faintViewController = checkFainting(user: user)
        
        _ = checkClassSelection(user: user)
        
        handleQuestCompletion(user)
        
        userRepository.registerPushDevice(user: user).observeCompleted {}
        setTimezoneOffset(user)

        if user.flags?.verifiedUsername == false {
            if var topController = UIApplication.shared.findKeyWindow()?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                if let controller = topController as? MainTabBarController {
                    let verifyViewController = StoryboardScene.User.verifyUsernameModalViewController.instantiate()
                    verifyViewController.modalTransitionStyle = .crossDissolve
                    verifyViewController.modalPresentationStyle = .overCurrentContext
                    controller.present(verifyViewController, animated: true, completion: nil)
                }
            }
        }
        #if !targetEnvironment(macCatalyst)
        AdhderAnalytics.shared.setUserProperty(key: "is_subscribed", value: user.isSubscribed ? "true" : "false")
        AdhderAnalytics.shared.setUserProperty(key: "has_party", value: user.party?.id != nil ? "true" : "false")
        AdhderAnalytics.shared.setUserProperty(key: "checkin_count", value: "\(user.loginIncentives)")
        AdhderAnalytics.shared.setAnalyticsConsents(user.preferences?.analyticsConsent == true)
        if let notifs = user.preferences?.pushNotifications {
            for (notif, value) in notifs.mapOfKeys() {
                AdhderAnalytics.shared.setUserProperty(key: "allowP\(notif)", value: "\(value)")
            }
        }
        #endif
    }
    
    private func handleQuestCompletion(_ user: UserProtocol) {
        if let questKey = user.party?.quest?.completed, !questKey.isEmpty {
            if let lastCompletion = lastQuestCompletionDisplayed, lastCompletion.timeIntervalSinceNow > -360 {
                return
            }
            lastQuestCompletionDisplayed = Date()
            let completionView = QuestCompletedAlertController(questKey: questKey)
            completionView.enqueue()
            userRepository.updateUser(key: "party.quest.completed", value: "").observeCompleted {}
        }
    }
    
    private func checkFainting(user: UserProtocol) -> FaintViewController? {
        if user.stats != nil && (user.stats?.health ?? 0) <= 0.0 && faintViewController == nil {
            let faintView = FaintViewController()
            faintView.show()
            return faintView
        }
        return faintViewController
    }
    
    func checkClassSelection(user: UserProtocol) -> Bool {
        if user.flags?.classSelected == false && user.preferences?.disableClasses == false && (user.stats?.level ?? 0) >= 10 {
            return showClassSelection(user: user)
        }
        return false
    }
    
    func showClassSelection(user: UserProtocol) -> Bool {
        if let lastSelection = lastClassSelectionDisplayed, lastSelection.timeIntervalSinceNow > -10 {
            return false
        }
        if classSelectionViewController == nil {
            let classSelectionController = StoryboardScene.Settings.classSelectionNavigationController.instantiate()
            if let topController = UIApplication.topViewController() {
                self.classSelectionViewController = classSelectionController.topViewController as? ClassSelectionViewController
                lastClassSelectionDisplayed = Date()
                classSelectionController.modalTransitionStyle = .crossDissolve
                classSelectionController.modalPresentationStyle = .overCurrentContext
                topController.present(classSelectionController, animated: true) {
                }
                return true
            }
        }
        return false
    }
    
    func shouldDisplayTutorialStep(key: String) -> Bool {
        return !(tutorialSteps[key] ?? true)
    }
    
    func markTutorialAsSeen(type: String, key: String) {
        disposable.add(userRepository.updateUser(key: "flags.tutorial.\(type).\(key)", value: true).observeCompleted {})
    }
    
    private func updateReminderNotifications(reminders: [ReminderProtocol], changes: ReactiveChangeset) {
        scheduleAllReminderNotifications(reminders: reminders)
    }
    private func scheduleAllReminderNotifications(reminders: [ReminderProtocol]) {
        let daysPerReminder = max(1, min(6, Int(64.0 / max(1, Double(reminders.count)))))
        let notificationCenter = UNUserNotificationCenter.current()
        var scheduledReminderKeys = [String]()
        for reminder in reminders where reminder.isValid {
            if let task = reminder.task, task.type == TaskType.todo && task.completed {
                continue
            }
            scheduledReminderKeys.append(contentsOf: self.scheduleNotifications(reminder: reminder, daysPerReminder: daysPerReminder))
        }
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            var toCancel = [String]()
            for request in requests where !scheduledReminderKeys.contains(request.identifier) && request.identifier.starts(with: "task") {
                toCancel.append(request.identifier)
            }
            if !toCancel.isEmpty {
                notificationCenter.removePendingNotificationRequests(withIdentifiers: toCancel)
            }
        })
    }
    
    private func scheduleNotifications(reminder: ReminderProtocol, daysPerReminder: Int) -> [String] {
        var keys = [String]()
        guard let task = reminder.task else {
            return keys
        }
        if reminder.id == nil || reminder.id?.isEmpty == true {
            return keys
        }
        if task.type == TaskType.daily {
            let calendar = Calendar(identifier: .gregorian)
            for day in 0...daysPerReminder {
                if day == 0 && task.completed {
                    continue
                }
                let checkedDate = Date(timeIntervalSinceNow: TimeInterval(day * 86400))
                if (task.isDue && day == 0) || task.dueOn(date: checkedDate, calendar: calendar) {
                    if let key = scheduleForDay(reminder: reminder, date: checkedDate, atTime: reminder.time) {
                        keys.append(key)
                    }
                }
            }
        } else if task.type == TaskType.todo, let time = reminder.time {
            if time > Date() && !task.completed {
                if let key = scheduleForDay(reminder: reminder, date: reminder.startDate ?? time, atTime: time) {
                    keys.append(key)
                }
            }
        }
        return keys
    }
    
    private func scheduleForDay(reminder: ReminderProtocol, date: Date, atTime: Date? = nil) -> String? {
        var fireDate = date
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        if let atTime = atTime {
            let timeComponents = calendar.dateComponents([.hour, .minute], from: atTime)
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
            components.timeZone = TimeZone.current
            if let newDate = calendar.date(from: components) {
                fireDate = newDate
            }
        }
        components.second = 0
        components.calendar = calendar
        
        if fireDate < Date() {
            return nil
        }
        
        let taskText = reminder.task?.text?.unicodeEmoji
        
        let content = UNMutableNotificationContent()
        content.body = taskText ?? ""
        content.sound = UNNotificationSound.default
        if let taskID = reminder.task?.id, let taskType = reminder.task?.type {
            content.userInfo = [
                "ID": reminder.id ?? "",
                "taskID": taskID,
                "taskType": taskType
            ]
        } else {
            content.userInfo = [ "ID": reminder.id ?? "" ]
        }
        content.categoryIdentifier = "taskCompletion"
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let notificationIdentifier = "task\(reminder.id ?? "")-\(components.month ?? 0)\(components.day ?? 0)"
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        logger.log("⏰ Notification \(request.identifier) for \(taskText ?? "") at \(components.date?.description ?? "")")
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                logger.log("Uh oh! We had an error: \(error)")
            }
        }
        return notificationIdentifier
    }
    
    private func setTimezoneOffset(_ user: UserProtocol) {
        let offset = -(NSTimeZone.local.secondsFromGMT() / 60)
        if user.preferences?.timezoneOffset != offset {
            userRepository.updateUser(key: "preferences.timezoneOffset", value: offset).observeCompleted {
                
            }
        }
    }
    
    public func cancelNotifications(for taskId: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { requests in
            var toCancel = [String]()
            for request in requests {
                if let userInfo = request.content.userInfo as? [String: Any],
                   let notificationTaskId = userInfo["taskID"] as? String,
                   notificationTaskId == taskId {
                    toCancel.append(request.identifier)
                }
            }
            if !toCancel.isEmpty {
                notificationCenter.removePendingNotificationRequests(withIdentifiers: toCancel)
            }
        }
    }
    
    public func rescheduleNotifications(for taskId: String) {
        disposable.add(taskRepository.getReminders().take(first: 1)
            .on(value: { [weak self] remindersResult in
                let taskReminders = remindersResult.value.filter { reminder in
                    return reminder.task?.id == taskId
                }
                if !taskReminders.isEmpty {
                    let daysPerReminder = max(1, min(6, Int(64.0 / max(1, Double(taskReminders.count)))))
                    for reminder in taskReminders where reminder.isValid {
                        _ = self?.scheduleNotifications(reminder: reminder, daysPerReminder: daysPerReminder)
                    }
                }
            })
            .start())
    }
}
