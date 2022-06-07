//
//  SprinkledApp.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

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
	
	@State var currentUser: User?
	
	var body: some Scene {
		WindowGroup {
			Group {
				if (currentUser != nil) {
					TabView {
						HomeView().tabItem {
							Image(systemName: "house")
						}
						MyPlantsView(viewModel: MyPlantsViewModel(dependencies: dependencies)).tabItem {
							Image(systemName: "leaf")
						}
						SearchView(viewModel: SearchViewModel(dependencies: dependencies)).tabItem {
							Image(systemName: "magnifyingglass")
						}
						SettingsView(viewModel: SettingsViewModel()).tabItem {
							Image(systemName: "gearshape")
						}
					}
				} else {
					AuthView(viewModel: AuthViewModel())
				}
			}.onAppear {
				self.currentUser = Auth.auth().currentUser
				Auth.auth().addStateDidChangeListener { _, user in
					self.currentUser = user
				}
			}
		}
	}
}
