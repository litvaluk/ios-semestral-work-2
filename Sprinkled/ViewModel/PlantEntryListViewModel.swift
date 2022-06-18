//
//  PlantEntryListViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 08.06.2022.
//

import Foundation

enum PlantEntryOwnerType {
	case user, team
}

final class PlantEntryListViewModel: ObservableObject {
	typealias Dependencies = HasPlantEntryRepository
	private let dependencies: Dependencies
	
	@Published var plantEntries: [PlantEntry] = []
	@Published var isFetchingPlantEntries = true
	@Published var isFetchedPlantEntriesAtLeastOnce = false
	@Published var error: Error?
	
	private let ownerType: PlantEntryOwnerType
	private let owner: String
	let navigationTitle: String
	
	init(ownerType: PlantEntryOwnerType, owner: String, navigationTitle: String, dependencies: Dependencies) {
		self.ownerType = ownerType
		self.owner = owner
		self.navigationTitle = navigationTitle
		self.dependencies = dependencies
	}
	
	@MainActor
	func fetchPlantEntries() async {
		isFetchingPlantEntries = true
		do {
			switch (ownerType) {
			case .user:
				plantEntries = try await dependencies.plantEntryRepository.getAllForUser(user: owner)
			case .team:
				plantEntries = try await dependencies.plantEntryRepository.getAllForTeam(team: owner)
			}
		} catch {
			self.error = Error.plantEntryFetchFailed
		}
		isFetchingPlantEntries = false
		isFetchedPlantEntriesAtLeastOnce = true
	}
}
