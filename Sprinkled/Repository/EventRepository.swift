//
//  EventRepository.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 13.06.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol HasEventRepository {
	var eventRepository: EventRepositoryType { get }
}

protocol EventRepositoryType {
	func getAll() async throws -> [Event]
	func create(event: Event) throws -> Void
}

final class EventRepository: EventRepositoryType {
	private let path: String = "events"
	private let store = Firestore.firestore()
	
	func getAll() async throws -> [Event] {
		let snapshot = try await store.collection(path).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: Event.self)
		}
	}
	
	func create(event: Event) throws {
		_ = try store.collection(path).addDocument(from: event)
	}
}
