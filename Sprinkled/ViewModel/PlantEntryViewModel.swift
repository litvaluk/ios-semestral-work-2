//
//  PlantEntryViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 12.06.2022.
//

import Foundation
import FirebaseAuth

final class PlantEntryViewModel: ObservableObject {
	typealias Dependencies = HasPlantRepository & HasPlantEntryRepository & HasEventRepository & HasUserRepository
	private let dependencies: Dependencies
	
	@Published var isFetchingPlant = false
	@Published var isFetchingEvents = false
	@Published var isFetchingUsers = false
	@Published var events: [Event] = []
	@Published var users: [User] = []
	@Published var pickerSelection = 0
	@Published var isAddEventSheetOpen = false
	@Published var eventPickerSelection = "Water"
	@Published var eventDatePickerSelection = Date.now
	let plantEntry: PlantEntry
	var plant: Plant?
	
	
	init(dependencies: Dependencies, plantEntry: PlantEntry) {
		self.dependencies = dependencies
		self.plantEntry = plantEntry
	}
	
	@MainActor
	func fetchPlant() async throws {
		isFetchingPlant = true
		plant = try await dependencies.plantRepository.get(id: plantEntry.plant!)
		isFetchingPlant = false
	}
	
	func deletePlantEntry(id: String) {
		dependencies.plantEntryRepository.delete(id: id)
	}
	
	@MainActor
	func fetchEvents() async throws {
		isFetchingEvents = true
		events = try await dependencies.eventRepository.getAllForPlantEntry(plantEntry: plantEntry.id!)
		isFetchingEvents = false
	}
	
	@MainActor
	func fetchUsers() async throws {
		isFetchingUsers = true
		users = try await dependencies.userRepository.getAll()
		isFetchingUsers = false
	}
	
	@MainActor
	func addNewEvent() async throws {
		try dependencies.eventRepository.create(event: Event(type: eventPickerSelection, createdBy: Auth.auth().currentUser!.uid, createdAt: eventDatePickerSelection, plantEntry: plantEntry.id!))
		isAddEventSheetOpen = false
	}
}
