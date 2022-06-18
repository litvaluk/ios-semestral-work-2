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
	@Published var error: Error?
	
	let plantEntry: PlantEntry
	var plant: Plant?
	
	
	init(dependencies: Dependencies, plantEntry: PlantEntry) {
		self.dependencies = dependencies
		self.plantEntry = plantEntry
	}
	
	@MainActor
	func fetchPlant() async {
		isFetchingPlant = true
		do {
			plant = try await dependencies.plantRepository.get(id: plantEntry.plant!)
		} catch {
			self.error = Error.plantFetchFailed
		}
		isFetchingPlant = false
	}
	
	func deletePlantEntry(id: String) {
		dependencies.plantEntryRepository.delete(id: id)
	}
	
	@MainActor
	func fetchEvents() async {
		isFetchingEvents = true
		do {
			events = try await dependencies.eventRepository.getAllForPlantEntry(plantEntry: plantEntry.id!)
		} catch {
			self.error = Error.eventFetchFailed
		}
		isFetchingEvents = false
	}
	
	@MainActor
	func fetchUsers() async {
		isFetchingUsers = true
		do {
			users = try await dependencies.userRepository.getAll()
		} catch {
			self.error = Error.userFetchFailed
		}
		isFetchingUsers = false
	}
	
	@MainActor
	func fetchReminders() async {
		isFetchingReminders = true
		do {
			reminders = try await dependencies.reminderRepository.getAllActiveForUserAndPlantEntry(userId: Auth.auth().currentUser!.uid, plantEntryId: plantEntry.id!)
		} catch {
			self.error = Error.reminderFetchFailed
		}
		isFetchingReminders = false
	}
	
	@MainActor
	func addNewEvent() async {
		do {
			try dependencies.eventRepository.create(event: Event(type: eventPickerSelection, createdBy: Auth.auth().currentUser!.uid, createdAt: eventDatePickerSelection, plantEntry: plantEntry.id!))
		} catch {
			self.error = Error.eventAddFailed
		}
		isAddEventSheetOpen = false
	}
	
	@MainActor
	func addNewReminder() async {
		do {
			try dependencies.notificationManager.addNotification(event: reminderEventPickerSelection, plantEntry: plantEntry, date: reminderDatePickerSelection)
		} catch {
			self.error = Error.reminderAddFailed
		}
		isAddReminderSheetOpen = false
	}
	
	func deleteReminder(id: String) {
		dependencies.notificationManager.removeNotification(id: id)
	}
}
