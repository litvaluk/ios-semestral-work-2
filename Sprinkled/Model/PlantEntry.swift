//
//  PlantEntry.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 07.06.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct PlantEntry: Codable, Identifiable, Comparable, Hashable {
	static func < (lhs: PlantEntry, rhs: PlantEntry) -> Bool {
		return lhs.name < rhs.name
	}
	
	@DocumentID var id: String?
	let name: String
	let plant: String?
	let user: String?
	let team: String?
	let createdBy: String?
	let createdAt: Date?
	let images: [String]
}
