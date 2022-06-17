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

extension Reminder {
	static let previewSingle = Reminder(id: "1", plantEntry: "x", plantName: "Jmeno rostliny", event: "Water", user: "x", date: .now)
	static let previewMultiple = [
		Reminder(id: "1", plantEntry: "1", plantName: "Jmeno rostliny 1", event: "Water", user: "1", date: Date(timeIntervalSince1970: 1655546400)),
		Reminder(id: "2", plantEntry: "1", plantName: "Jmeno rostliny 1", event: "Fertilize", user: "1", date: Date(timeIntervalSince1970: 1655632800)),
		Reminder(id: "3", plantEntry: "3", plantName: "Jmeno rostliny 3", event: "Prune", user: "1", date: Date(timeIntervalSince1970: 1655636400)),
		Reminder(id: "4", plantEntry: "3", plantName: "Jmeno rostliny 3", event: "Repot", user: "2", date: Date(timeIntervalSince1970: 1655895600)),
		Reminder(id: "5", plantEntry: "2", plantName: "Jmeno rostliny 2", event: "Mist", user: "3", date: Date(timeIntervalSince1970: 1655899200))
	]
}
