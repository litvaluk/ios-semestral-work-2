//
//  HomeViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 17.06.2022.
//

import Foundation
import FirebaseAuth
import Collections

final class HomeViewModel: ObservableObject {
	typealias Dependencies = HasReminderRepository & HasPlantEntryRepository
	private let dependencies: Dependencies
	
	@Published var reminderMap: OrderedDictionary<String, [Reminder]> = [:]
	@Published var isFetchingReminders = false
	
	var uniquePlantEntries: [PlantEntry] = []
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	@MainActor
	func fetchReminders() async throws {
		isFetchingReminders = true
		let reminders = try await dependencies.reminderRepository.getAllActiveForUser(userId: Auth.auth().currentUser!.uid)
		try await fetchUniquePlantEntries(reminders: reminders)
		let df = DateFormatter()
		df.dateFormat = "dd MMM"
		reminderMap = OrderedDictionary.init(grouping: reminders) { reminder in
			df.string(from: reminder.date)
		}
		isFetchingReminders = false
	}
	
	private func fetchUniquePlantEntries(reminders: [Reminder]) async throws {
		var uniquePlantEntryIds: [String] = []
		for reminder in reminders {
			if(!uniquePlantEntryIds.contains(reminder.plantEntry)) {
				uniquePlantEntryIds.append(reminder.plantEntry)
			}
		}
		uniquePlantEntries = try await dependencies.plantEntryRepository.getMultiple(ids: uniquePlantEntryIds)
	}
	
}
