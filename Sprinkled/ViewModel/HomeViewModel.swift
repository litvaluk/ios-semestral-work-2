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
	@Published var error: Error?
	
	var uniquePlantEntries: [PlantEntry] = []
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	@MainActor
	func fetchReminders() async {
		isFetchingReminders = true
		guard let currentUser = Auth.auth().currentUser else {
			isFetchingReminders = false
			return
		}
		do {
			let reminders = try await dependencies.reminderRepository.getAllActiveForUser(userId: currentUser.uid)
			try await fetchUniquePlantEntries(reminders: reminders)
			let df = DateFormatter()
			df.dateFormat = "dd MMM"
			reminderMap = OrderedDictionary.init(grouping: reminders) { reminder in
				df.string(from: reminder.date)
			}
		} catch {
			self.error = Error.reminderFetchFailed
		}
	}
	
	private func fetchUniquePlantEntries(reminders: [Reminder]) async throws {
		var uniquePlantEntryIds: [String] = []
		for reminder in reminders {
			if(!uniquePlantEntryIds.contains(reminder.plantEntry)) {
				uniquePlantEntryIds.append(reminder.plantEntry)
			}
		}
		if (!uniquePlantEntryIds.isEmpty) {
			uniquePlantEntries = try await dependencies.plantEntryRepository.getMultiple(ids: uniquePlantEntryIds)
		} else {
			uniquePlantEntries = []
		}
	}
	
}
