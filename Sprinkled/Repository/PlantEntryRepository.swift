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
}
