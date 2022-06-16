//
//  Event.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 13.06.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Event: Codable, Identifiable, Comparable, Hashable {
	static func < (lhs: Event, rhs: Event) -> Bool {
		return lhs.createdAt > rhs.createdAt
	}
	
	@DocumentID var id: String?
	let type: String
	let createdBy: String
	let createdAt: Date
	let plantEntry: String
}

extension Event {
	static let previewSingle = Event(id: "1", type: "Water", createdBy: "1", createdAt: .now, plantEntry: "1")
	static let previewMultiple = [
		previewSingle,
		previewSingle,
		previewSingle
	]
}
