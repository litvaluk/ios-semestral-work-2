//
//  TeamSettingsView.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 11.06.2022.
//

import SwiftUI
import FirebaseAuth

struct TeamSettingsView: View {
	@StateObject var viewModel: TeamSettingsViewModel
	
    var body: some View {
		List {
			ForEach(viewModel.users) { member in
				Text(member.email)
			}
		}
		.navigationTitle("Members")
		.onAppear {
			Task {
				do {
					try await viewModel.fetchUsers()
				} catch {
					print("cannot fetch users")
				}
			}
		}
    }
}

struct TeamSettingsView_Previews: PreviewProvider {
    static var previews: some View {
		let team = Team(name: "Team", createdBy: "1234", createdAt: .now, users: ["1234"])
        TeamSettingsView(viewModel: TeamSettingsViewModel(team: team, dependencies: dependencies))
    }
}
