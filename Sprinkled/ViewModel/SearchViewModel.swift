//
//  SearchViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

import Foundation
import FirebaseAuth

final class SearchViewModel: ObservableObject {
	typealias Dependencies = HasPlantRepository
	private let dependencies: Dependencies
	
	@Published var plants: [Plant] = []
	@Published var searchText = ""
	@Published var isFetching = true
	@Published var isFetchedAtLeastOnce = false
	@Published var error: Error?
	
	var filteredPlants: [Plant] {
		if searchText.isEmpty {
			return plants
		} else {
			return plants.filter {
				$0.commonName?.localizedCaseInsensitiveContains(searchText) ?? false || $0.latinName.localizedCaseInsensitiveContains(searchText)
			}
		}
	}
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	@MainActor
	func fetchPlants() async {
		isFetching = true
		do {
			plants = try await dependencies.plantRepository.getAll()
		} catch {
			self.error = Error.plantFetchFailed
		}
		isFetching = false
		isFetchedAtLeastOnce = true
	}
}
