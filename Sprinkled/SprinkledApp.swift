//
//  SprinkledApp.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		return true
	}
}

@main
struct SprinkledApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	var body: some Scene {
		WindowGroup {
			SearchView(viewModel: SearchViewModel(dependencies: dependencies))
		}
	}
}
