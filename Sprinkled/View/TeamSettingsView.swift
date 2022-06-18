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
	@StateObject var myPlantsViewModel: MyPlantsViewModel
	
    var body: some View {
		List {
			ForEach(viewModel.users) { member in
				Text(member.email)
			}
		}
		.navigationTitle("Members")
		.navigationBarItems(trailing: NavigationLink {
				List(viewModel.filteredAllUsers.sorted()) { user in
					Button {
						viewModel.clickedUserEmail = user.email
						Task {
							await viewModel.addUserToTeam(user: user)
							await viewModel.fetchUsers()
							await myPlantsViewModel.fetchTeams()
							viewModel.isShowingAlert.toggle()
						}
					} label: {
						Text(user.email)
							.foregroundColor(.primary)
					}
				}
				.searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
				.navigationTitle("Add new member")
				.alert(isPresented: $viewModel.isShowingAlert) {
					Alert(title: Text("New member added!"), message: Text(viewModel.clickedUserEmail), dismissButton: .default(Text("Ok")))
				}
		} label: {
			Image(systemName: "plus")
		})
		.errorAlert(error: $viewModel.error)
		.onAppear {
			Task {
				await viewModel.fetchUsers()
			}
		}
    }
}

struct TeamSettingsView_Previews: PreviewProvider {
    static var previews: some View {
		let team = Team(name: "Team", createdBy: "1234", createdAt: .now, users: ["1234"])
        TeamSettingsView(viewModel: TeamSettingsViewModel(team: team, dependencies: dependencies), myPlantsViewModel: MyPlantsViewModel(dependencies: dependencies))
    }
}
