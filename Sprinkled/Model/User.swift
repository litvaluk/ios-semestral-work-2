//
//  User.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 11.06.2022.
//
import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable, Comparable, Hashable {
	static func < (lhs: User, rhs: User) -> Bool {
		return lhs.email < rhs.email
	}
	
	@DocumentID var id: String?
	let email: String
}
