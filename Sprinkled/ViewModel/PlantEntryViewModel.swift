//
//  PlantEntryViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 12.06.2022.
//

import Foundation

final class PlantEntryViewModel: ObservableObject {
	typealias Dependencies = HasPlantRepository & HasPlantEntryRepository
	private let dependencies: Dependencies
	
	@Published var isFetching = false
	
	let plantEntry: PlantEntry
	var plant: Plant?
	
	init(dependencies: Dependencies, plantEntry: PlantEntry) {
		self.dependencies = dependencies
		self.plantEntry = plantEntry
	}
	
	@MainActor
	func fetchPlant() async throws {
		isFetching = true
		plant = try await dependencies.plantRepository.get(id: plantEntry.plant!)
		isFetching = false
	}
	
	func deletePlantEntry(id: String) {
		dependencies.plantEntryRepository.delete(id: id)
	}
}
