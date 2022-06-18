//
//  Utils.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 18.06.2022.
//

import SwiftUI

func getEventImage(eventType: String) -> Image {
	switch(eventType) {
	case "Water":
		return Image("Water")
			.renderingMode(.template)
	case "Mist":
		return Image("Mist")
			.renderingMode(.template)
	case "Repot":
		return Image("Repot")
			.renderingMode(.template)
	case "Fertilize":
		return Image("Fertilize")
			.renderingMode(.template)
	default: // prune
		return Image(systemName: "scissors")
	}
}
