//
//  Plant.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Plant: Codable, Identifiable, Comparable {
	static func < (lhs: Plant, rhs: Plant) -> Bool {
		return lhs.latinName < rhs.latinName
	}
	
	@DocumentID var id: String?
	let latinName: String
	let commonName: String?
	let description: String?
	let pictureUrl: String?
	let temperatureMin: Int?
	let temperatureMax: Int?
	let leafColor: String?
	let bloomColor: String?
	let light: String?
	let zoneMin: Int?
	let zoneMax: Int?
}
