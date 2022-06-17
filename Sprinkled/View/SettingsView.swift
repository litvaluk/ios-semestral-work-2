//
//  SettingsView.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 06.06.2022.
//

import FirebaseAuth
import SwiftUI

struct SettingsView: View {
	@StateObject var viewModel: SettingsViewModel
	
    var body: some View {
		NavigationView {
		   Form {
			   Section(header: Text("Notifications"), footer: Text("Check this to enable reminder notifications.")) {
				   Toggle(isOn: $viewModel.reminderNotificationsToggleOn) {
					   Text("Reminder notifications")
				   }
				   .onChange(of: viewModel.reminderNotificationsToggleOn) { _ in
					   viewModel.onReminderNotificationsToggleChange()
				   }
			   }.navigationTitle("Settings")
			   Section {
				   Button(action: viewModel.signOut) {
					   HStack{
						   Spacer()
						   Text("Sign Out")
						   Spacer()
					   }
				   }
				   .foregroundColor(.red)
			   }
		   }
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(dependencies: dependencies))
    }
}
