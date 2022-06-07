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
			   Section(header: Text("Notifications"), footer: Text("Check this to enable push notifications.")) {
				   Toggle(isOn: $viewModel.pushNotificationsEnabled) {
					   Text("Push notifications")
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
        SettingsView(viewModel: SettingsViewModel())
    }
}
