//
//  MyPlantsViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 07.06.2022.
//

import Foundation

final class MyPlantsViewModel: ObservableObject {
	typealias Dependencies = HasPlantEntryRepository & HasTeamRepository
	private let dependencies: Dependencies
	
	@Published var selectedOption = 0
	@Published var plantEntries: [PlantEntry] = []
	@Published var isFetchingPlantEntries = true
	@Published var isFetchedPlantEntriesAtLeastOnce = false
	@Published var teams: [Team] = []
	@Published var isFetchingTeams = true
	@Published var isFetchedTeamsAtLeastOnce = false
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	@MainActor
	func fetchPlantEntries() async throws {
		isFetchingPlantEntries = true
		plantEntries = try await dependencies.plantEntryRepository.getAllForUser()
		isFetchingPlantEntries = false
		isFetchedPlantEntriesAtLeastOnce = true
	}
	
	@MainActor
	func fetchTeams() async throws {
		isFetchingTeams = true
		teams = try await dependencies.teamRepository.getAllForUser()
		isFetchingTeams = false
		isFetchedTeamsAtLeastOnce = true
	}
}
