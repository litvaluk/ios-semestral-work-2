//
//  MyPlantsViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 07.06.2022.
//

import Foundation

final class MyPlantsViewModel: ObservableObject {
	typealias Dependencies = HasPlantEntryRepository
	private let dependencies: Dependencies
	
	@Published var selectedOption = 0
	@Published var plantEntries: [PlantEntry] = []
	@Published var isFetching = true
	@Published var isFetchedAtLeastOnce = false
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	@MainActor
	func fetchPlantEntries() async throws {
		isFetching = true
		plantEntries = try await dependencies.plantEntryRepository.getAllForUser()
		isFetching = false
		isFetchedAtLeastOnce = true
	}
}
