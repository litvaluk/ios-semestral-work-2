//
//  Reminder.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 17.06.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Reminder: Codable, Identifiable, Comparable, Hashable {
	static func < (lhs: Reminder, rhs: Reminder) -> Bool {
		return lhs.date < rhs.date
	}
	
	@DocumentID var id: String?
	let plantEntry: String
	let plantName: String
	let event: String
	let user: String
	let date: Date
}
