//
//  TeamSettingsViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 11.06.2022.
//

import Foundation
import SwiftUI

final class TeamSettingsViewModel: ObservableObject {
	typealias Dependencies =  HasTeamRepository & HasUserRepository
	private let dependencies: Dependencies
	
	@Published var isAddNewMemberSheetShown = false
	@Published var newMemberEmail = ""
	@Published var isAddingMember = false
	@Published var users: [User] = []
	@Published var allUsers: [User] = []
	@Published var isFetchingUsers = false
	@Published var searchText = ""
	@Published var isShowingAlert = false
	
	var filteredAllUsers: [User] {
		if searchText.isEmpty {
			return allUsers
		} else {
			return allUsers.filter {
				$0.email.localizedCaseInsensitiveContains(searchText)
			}
		}
	}
	
	var team: Team
	
	init(team: Team, dependencies: Dependencies) {
		self.team = team
		self.dependencies = dependencies
	}
	
	@MainActor
	func fetchUsers() async throws {
		isFetchingUsers = true
		allUsers = try await dependencies.userRepository.getAll()
		users = allUsers.filter { user in
			team.users.contains(user.id!)
		}
		isFetchingUsers = false
	}
	
	@MainActor
	func addUserToTeam(user: User) async throws {
		var newUsers = team.users
		newUsers.append(user.id!)
		let newTeam = Team(id: team.id, name: team.name, createdBy: team.createdBy, createdAt: team.createdAt, users: newUsers)
		try await dependencies.teamRepository.update(team: newTeam)
		team = newTeam
	}
}
