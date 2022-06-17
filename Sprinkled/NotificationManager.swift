//
//  NotificationManager.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 17.06.2022.
//

import Foundation
import UserNotifications
import FirebaseAuth
import UIKit

protocol HasNotificationManager {
	var notificationManager: NotificationManagerType { get }
}

protocol NotificationManagerType {
	func requestPermission() -> Void
	func enableNotifications() -> Void
	func disableNotifications() -> Void
	func notificationsEnabled() -> Bool
	func getPendingNotifications() async -> [UNNotificationRequest]
	func addNotification(event: String, plantEntry: PlantEntry, date: Date) throws -> Void
	func removeNotification(id: String) -> Void
	func pauseNotifications() -> Void
	func removeDeliveredNotifications() -> Void
	func resumeNotifications() async throws -> Void
	func resetBadges() -> Void
}

final class NotificationManager: NotificationManagerType {
	typealias Dependencies = HasReminderRepository
	private let dependencies: Dependencies
	
	let notificationsKey = "NotificationsEnabled"
	var badges: NSNumber = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber)
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	func requestPermission() {
		let options: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { success, error in
			if let error = error {
				print("failed to get notification permission: \(error)")
				return
			}
		})
	}
	
	func notificationsEnabled() -> Bool {
		return UserDefaults.standard.bool(forKey: notificationsKey)
	}
	
	func enableNotifications() -> Void {
		UserDefaults.standard.set(true, forKey: notificationsKey)
	}
	
	func disableNotifications() -> Void {
		UserDefaults.standard.set(false, forKey: notificationsKey)
	}
	
	func getPendingNotifications() async -> [UNNotificationRequest] {
		return await UNUserNotificationCenter.current().pendingNotificationRequests()
	}
	
	func addNotification(event: String, plantEntry: PlantEntry, date: Date) throws {
		let uuid = scheduleNotification(event: event, plantName: plantEntry.name, date: date)
		try dependencies.reminderRepository.create(reminder: Reminder(id: uuid, plantEntry: plantEntry.id!, plantName: plantEntry.name, event: event, user: Auth.auth().currentUser!.uid, date: date))
	}
	
	func removeNotification(id: String) {
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
		dependencies.reminderRepository.delete(id: id)
	}
	
	func pauseNotifications() {
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
		UNUserNotificationCenter.current().removeAllDeliveredNotifications()
	}
	
	func removeDeliveredNotifications() {
		UNUserNotificationCenter.current().removeAllDeliveredNotifications()
	}
	
	func resumeNotifications() async throws {
		let reminders = try await dependencies.reminderRepository.getAllActiveForUser(userId: Auth.auth().currentUser!.uid)
		for reminder in reminders {
			scheduleNotification(uuid: reminder.id!, event: reminder.event, plantName: reminder.plantName, date: reminder.date)
		}
	}
	
	func resetBadges() {
		badges = 0
		UIApplication.shared.applicationIconBadgeNumber = 0
	}
	
	private func scheduleNotification(event: String, plantName: String, date: Date) -> String {
		let uuid = UUID().uuidString
		scheduleNotification(uuid: uuid, event: event, plantName: plantName, date: date)
		return uuid
	}
	
	private func scheduleNotification(uuid: String, event: String, plantName: String, date: Date) {
		let content = UNMutableNotificationContent()
		content.title = "\(event) reminder"
		content.subtitle = plantName
		content.sound = .default
		badges = NSNumber(value: badges.intValue + 1)
		content.badge = badges
		
		var dateComponents = DateComponents()
		dateComponents.hour = Calendar.current.component(.hour, from: date)
		dateComponents.minute = Calendar.current.component(.minute, from: date)
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
		
		let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(request)
	}
}
