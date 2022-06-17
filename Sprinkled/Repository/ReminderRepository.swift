//
//  ReminderRepository.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 17.06.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol HasReminderRepository {
	var reminderRepository: ReminderRepositoryType { get }
}

protocol ReminderRepositoryType {
	func getAllActiveForUser(userId: String) async throws -> [Reminder]
	func create(reminder: Reminder) throws -> Void
	func delete(id: String) -> Void
}

final class ReminderRepository: ReminderRepositoryType {
	private let path: String = "reminders"
	private let store = Firestore.firestore()
	
	func getAllActiveForUser(userId: String) async throws -> [Reminder] {
		let snapshot = try await store.collection(path).whereField("user", isEqualTo: userId).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: Reminder.self)
		}.filter { reminder in
			reminder.date > .now
		}
	}
	
	func create(reminder: Reminder) throws {
		_ = try store.collection(path).addDocument(from: reminder)
	}
	
	func delete(id: String) {
		store.collection(path).document(id).delete()
	}
}
