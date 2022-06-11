//
//  TeamRepository.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 08.06.2022.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol HasTeamRepository {
	var teamRepository: TeamRepositoryType { get }
}

protocol TeamRepositoryType {
	func getAll() async throws -> [Team]
	func getAllForUser() async throws -> [Team]
	func create(team: Team) throws -> Void
	func update(team: Team) async throws -> Void
}

final class TeamRepository: TeamRepositoryType {
	private let path: String = "teams"
	private let store = Firestore.firestore()
	
	func getAll() async throws -> [Team] {
		let snapshot = try await store.collection(path).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: Team.self)
		}
	}
	
	func getAllForUser() async throws -> [Team] {
		if let user = Auth.auth().currentUser {
			let snapshot = try await store.collection(path).whereField("users", arrayContains: user.uid).getDocuments()
			return snapshot.documents.compactMap { document in
				try? document.data(as: Team.self)
			}
		}
		return []
	}
	
	func create(team: Team) throws {
		_ = try store.collection(path).addDocument(from: team)
	}
	
	func update(team: Team) async throws {
		_ = try store.collection(path).document(team.id!).setData(from: team)
	}
}
