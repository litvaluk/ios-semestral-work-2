//
//  SettingsViewMOdel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 07.06.2022.
//

import FirebaseAuth
import Foundation

final class SettingsViewModel: ObservableObject {
	typealias Dependencies = HasNotificationManager & HasReminderRepository
	private let dependencies: Dependencies
	
	@Published var reminderNotificationsToggleOn: Bool
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
		reminderNotificationsToggleOn = self.dependencies.notificationManager.notificationsEnabled()
	}
	
	func signOut() {
		guard let _ = try? Auth.auth().signOut() else {
			print("Sign Out not successful")
			return
		}
	}
	
	func onReminderNotificationsToggleChange() {
		if (reminderNotificationsToggleOn) {
			dependencies.notificationManager.enableNotifications()
		} else {
			dependencies.notificationManager.disableNotifications()
		}
		dependencies.notificationManager.requestPermission()
	}
}
