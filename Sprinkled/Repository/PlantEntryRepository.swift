//
//  PlantEntryRepository.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 07.06.2022.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol HasPlantEntryRepository {
	var plantEntryRepository: PlantEntryRepositoryType { get }
}

protocol PlantEntryRepositoryType {
	func getAll() async throws -> [PlantEntry]
	func getAllForUser() async throws -> [PlantEntry]
	func getAllForUser(user: String) async throws -> [PlantEntry]
	func getAllForTeam(team: String) async throws -> [PlantEntry]
	func getMultiple(ids: [String]) async throws -> [PlantEntry]
	func create(plantEntry: PlantEntry) throws -> Void
	func delete(id: String) -> Void
}

final class PlantEntryRepository: PlantEntryRepositoryType {
	private let path: String = "plant_entries"
	private let store = Firestore.firestore()
	
	func getAll() async throws -> [PlantEntry] {
		let snapshot = try await store.collection(path).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: PlantEntry.self)
		}
	}
	
	func getAllForUser() async throws -> [PlantEntry] {
		if let user = Auth.auth().currentUser {
			let snapshot = try await store.collection(path).whereField("user", isEqualTo: user.uid).getDocuments()
			return snapshot.documents.compactMap { document in
				try? document.data(as: PlantEntry.self)
			}
		}
		return []
	}
	
	func getAllForUser(user: String) async throws -> [PlantEntry] {
		let snapshot = try await store.collection(path).whereField("user", isEqualTo: user).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: PlantEntry.self)
		}
	}
	
	func getAllForTeam(team: String) async throws -> [PlantEntry] {
		let snapshot = try await store.collection(path).whereField("team", isEqualTo: team).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: PlantEntry.self)
		}
	}
	
	func getMultiple(ids: [String]) async throws -> [PlantEntry] {
		let snapshot = try await store.collection(path).whereField(FieldPath.documentID(), in: ids).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: PlantEntry.self)
		}
	}
	
	func create(plantEntry: PlantEntry) throws {
		_ = try store.collection(path).addDocument(from: plantEntry)
	}
	
	func delete(id: String) {
		store.collection(path).document(id).delete()
	}
}
