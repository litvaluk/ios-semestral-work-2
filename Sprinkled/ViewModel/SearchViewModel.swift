//
//  SearchViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

import Foundation

final class SearchViewModel: ObservableObject {
	typealias Dependencies = HasPlantRepository
	private let dependencies: Dependencies
	
	@Published var plants: [Plant] = []
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	@MainActor
	func fetchPlants() async throws {
		plants = try await dependencies.plantRepository.getAll()
	}
}
