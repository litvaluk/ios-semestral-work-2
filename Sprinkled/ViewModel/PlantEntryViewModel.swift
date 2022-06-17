//
//  PlantEntryViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 12.06.2022.
//

import Foundation
import FirebaseAuth

final class PlantEntryViewModel: ObservableObject {
	typealias Dependencies = HasPlantRepository & HasPlantEntryRepository & HasEventRepository & HasUserRepository & HasNotificationManager & HasReminderRepository
	private let dependencies: Dependencies
	
	@Published var isFetchingPlant = false
	@Published var isFetchingEvents = false
	@Published var isFetchingReminders = false
	@Published var isFetchingUsers = false
	@Published var events: [Event] = []
	@Published var users: [User] = []
	@Published var reminders: [Reminder] = []
	@Published var pickerSelection = 0
	@Published var isAddEventSheetOpen = false
	@Published var eventPickerSelection = "Water"
	@Published var eventDatePickerSelection = Date.now
	@Published var isAddReminderSheetOpen = false
	@Published var reminderEventPickerSelection = "Water"
	@Published var reminderDatePickerSelection = Date.now
	
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
	func fetchReminders() async throws {
		isFetchingReminders = true
		reminders = try await dependencies.reminderRepository.getAllActiveForUser(userId: Auth.auth().currentUser!.uid)
		isFetchingReminders = false
	}
	
	@MainActor
	func addNewEvent() async throws {
		try dependencies.eventRepository.create(event: Event(type: eventPickerSelection, createdBy: Auth.auth().currentUser!.uid, createdAt: eventDatePickerSelection, plantEntry: plantEntry.id!))
		isAddEventSheetOpen = false
	}
	
	@MainActor
	func addNewReminder() async throws {
		try dependencies.notificationManager.addNotification(event: reminderEventPickerSelection, plantEntry: plantEntry, date: reminderDatePickerSelection)
		isAddReminderSheetOpen = false
	}
}
