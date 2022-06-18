//
//  PlantViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 10.06.2022.
//

import Foundation
import FirebaseAuth

final class PlantViewModel: ObservableObject {
	typealias Dependencies =  HasTeamRepository & HasPlantEntryRepository
	private let dependencies: Dependencies
	
	@Published var isAddNewPlantEntrySheetShown = false
	@Published var newPlantEntryName = ""
	@Published var isAddingPlantEntry = false
	@Published var ownerSelection = 0
	@Published var teamSelection: String?
	@Published var teams: [Team] = []
	@Published var isFetchingTeams = false
	@Published var error: Error?
	
	let plant: Plant
	
	init(plant: Plant, dependencies: Dependencies) {
		self.plant = plant
		self.dependencies = dependencies
	}

	func addNewPlantEntry() {
		isAddingPlantEntry = true
		var newPlantEntry: PlantEntry
		if (ownerSelection == 0) {
			newPlantEntry = PlantEntry(name: newPlantEntryName, plant: plant.id, user: Auth.auth().currentUser!.uid, team: nil, createdBy: Auth.auth().currentUser!.uid, createdAt: .now, images: [plant.pictureUrl!])
		} else {
			newPlantEntry = PlantEntry(name: newPlantEntryName, plant: plant.id, user: nil, team: teamSelection, createdBy: Auth.auth().currentUser!.uid, createdAt: .now, images: [plant.pictureUrl!])
		}
		do {
			try dependencies.plantEntryRepository.create(plantEntry: newPlantEntry)
		} catch {
			self.error = Error.plantEntryAddFailed
		}
		isAddingPlantEntry = false
		isAddNewPlantEntrySheetShown = false
	}
	
	@MainActor
	func fetchTeams() async {
		isFetchingTeams = true
		do {
			teams = try await dependencies.teamRepository.getAllForUser()
		} catch {
			self.error = Error.teamFetchFailed
		}
		isFetchingTeams = false
	}
	
}
