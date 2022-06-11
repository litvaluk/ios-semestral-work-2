//
//  UserRepository.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 11.06.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol HasUserRepository {
	var userRepository: UserRepositoryType { get }
}

protocol UserRepositoryType {
	func getAll() async throws -> [User]
	func create(user: User) throws -> Void
}

final class UserRepository: UserRepositoryType {
	private let path: String = "users"
	private let store = Firestore.firestore()
	
	func getAll() async throws -> [User] {
		let snapshot = try await store.collection(path).getDocuments()
		return snapshot.documents.compactMap { document in
			try? document.data(as: User.self)
		}
	}
	
	func create(user: User) throws {
		_ = try store.collection(path).addDocument(from: user)
	}
}
