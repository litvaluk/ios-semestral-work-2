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
	
	let plant: Plant
	
	init(plant: Plant, dependencies: Dependencies) {
		self.plant = plant
		self.dependencies = dependencies
	}

	func addNewPlantEntry() {
		isAddingPlantEntry = true
		let newPlantEntry = PlantEntry(name: newPlantEntryName, plant: plant.id, user: Auth.auth().currentUser!.uid, team: nil, createdBy: Auth.auth().currentUser!.uid, createdAt: .now, images: [plant.pictureUrl!])
		try? dependencies.plantEntryRepository.create(plantEntry: newPlantEntry)
		isAddingPlantEntry = false
		isAddNewPlantEntrySheetShown = false
	}
	
}
