//
//  TeamSettingsViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 11.06.2022.
//

import Foundation

final class TeamSettingsViewModel: ObservableObject {
	typealias Dependencies =  HasTeamRepository & HasUserRepository
	private let dependencies: Dependencies
	
	@Published var isAddNewMemberSheetShown = false
	@Published var newMemberEmail = ""
	@Published var isAddingMember = false
	@Published var users: [User] = []
	@Published var isFetchingUsers = false
	
	let team: Team
	
	init(team: Team, dependencies: Dependencies) {
		self.team = team
		self.dependencies = dependencies
	}
	
	@MainActor
	func fetchUsers() async throws {
		isFetchingUsers = true
		users = try await dependencies.userRepository.getAll().filter { user in
			team.users.contains(user.id!)
		}
		isFetchingUsers = false
	}
}
