//
//  SprinkledTabViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 18.06.2022.
//

import Foundation
import FirebaseAuth

final class SprinkledTabViewModel: ObservableObject {
	typealias Dependencies = HasNotificationManager
	private let dependencies: Dependencies
	
	@Published var currentUser: FirebaseAuth.User?
	@Published var error: Error?
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	@MainActor
	func onAppear() async {
		self.currentUser = Auth.auth().currentUser
		self.dependencies.notificationManager.resetBadges()
		Auth.auth().addStateDidChangeListener { _, user in
			self.currentUser = user
			Task {
				if (user != nil) {
					do {
						try await self.dependencies.notificationManager.resumeNotifications()
					} catch {
						self.error = Error.notificationsResumeFailed
					}
				} else {
					self.dependencies.notificationManager.pauseNotifications()
				}
			}
		}
	}
}
