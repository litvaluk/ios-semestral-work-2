//
//  SprinkledApp.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		return true
	}
}

@main
struct SprinkledApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	@State var currentUser: FirebaseAuth.User?
	
	var body: some Scene {
		WindowGroup {
			Group {
				if (currentUser != nil) {
					TabView {
						HomeView(viewModel: HomeViewModel(dependencies: dependencies)).tabItem {
							Image(systemName: "house")
						}
						MyPlantsView(viewModel: MyPlantsViewModel(dependencies: dependencies)).tabItem {
							Image(systemName: "leaf")
						}
						SearchView(viewModel: SearchViewModel(dependencies: dependencies)).tabItem {
							Image(systemName: "magnifyingglass")
						}
						SettingsView(viewModel: SettingsViewModel(dependencies: dependencies)).tabItem {
							Image(systemName: "gearshape")
						}
					}
				} else {
					AuthView(viewModel: AuthViewModel(dependencies: dependencies))
				}
			}
			.accentColor(.sprinkledGreen)
			.onAppear {
				self.currentUser = Auth.auth().currentUser
				dependencies.notificationManager.resetBadges()
				Auth.auth().addStateDidChangeListener { _, user in
					self.currentUser = user
					Task {
						if (user != nil) {
							do {
								try await dependencies.notificationManager.resumeNotifications()
							} catch {
								print("cannot resume notifications")
							}
						} else {
							dependencies.notificationManager.pauseNotifications()
						}
					}
				}
			}
		}
	}
}

extension Color {
	static let sprinkledGreen = Color("SprinkledGreen")
	static let sprinkledPaleGreen = Color("SprinkledPaleGreen")
	static let sprinkledGray = Color("SprinkledGray")
}
