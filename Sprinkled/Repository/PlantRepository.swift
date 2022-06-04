//
//  PlantRepository.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol HasPlantRepository {
	var plantRepository: PlantRepositoryType { get }
}

protocol PlantRepositoryType {
	func getAll() async throws -> [Plant]
}

final class PlantRepository: PlantRepositoryType {
	private let path: String = "plants"
	private let store = Firestore.firestore()
	
	func getAll() async throws -> [Plant] {
		let snapshot = try await store.collection(path).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: Plant.self)
		}
	}
}
