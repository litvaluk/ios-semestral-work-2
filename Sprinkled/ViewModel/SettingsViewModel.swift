//
//  SettingsViewMOdel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 07.06.2022.
//

import FirebaseAuth
import Foundation

final class SettingsViewModel: ObservableObject {
	@Published var pushNotificationsEnabled = true
	
	func signOut() {
		guard let _ = try? Auth.auth().signOut() else {
			print("Sign Out not successful")
			return
		}
	}
}
