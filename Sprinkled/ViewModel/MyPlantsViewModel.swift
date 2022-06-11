//
//  MyPlantsViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 07.06.2022.
//

import Foundation
import FirebaseAuth

final class MyPlantsViewModel: ObservableObject {
	typealias Dependencies = HasPlantEntryRepository & HasTeamRepository
	private let dependencies: Dependencies
	
	@Published var selectedOption = 0
	@Published var teams: [Team] = []
	@Published var isFetchingTeams = true
	@Published var isFetchedTeamsAtLeastOnce = false
	@Published var isAddNewTeamSheetShown = false
	@Published var newTeamName = ""
	@Published var isAddingTeam = false
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	@MainActor
	func fetchTeams() async throws {
		isFetchingTeams = true
		teams = try await dependencies.teamRepository.getAllForUser()
		isFetchingTeams = false
		isFetchedTeamsAtLeastOnce = true
	}
	
	func addNewTeam() {
		isAddingTeam = true
		let newTeam = Team(name: newTeamName, createdBy: Auth.auth().currentUser!.uid, createdAt: .now, users: [Auth.auth().currentUser!.uid])
		try? dependencies.teamRepository.create(team: newTeam)
		isAddingTeam = false
		isAddNewTeamSheetShown = false
		Task {
			do {
				try await fetchTeams()
			} catch {
				print("cannot fetch teams")
			}
		}
	}
}
