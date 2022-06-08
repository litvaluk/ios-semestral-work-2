//
//  Team.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 08.06.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Team: Codable, Identifiable, Comparable, Hashable {
	static func < (lhs: Team, rhs: Team) -> Bool {
		return lhs.name < rhs.name
	}
	
	@DocumentID var id: String?
	let name: String
	let createdBy: String
	let createdAt: Date
	let users: [String]
}
