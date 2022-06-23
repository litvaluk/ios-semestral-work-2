//
//  Error.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 18.06.2022.
//

import Foundation
import SwiftUI

enum Error: LocalizedError {
	case generic, plantFetchFailed, plantEntryFetchFailed, plantEntryAddFailed, teamFetchFailed, userToTeamAddFailed, teamCreationFailed, userFetchFailed, eventFetchFailed, eventAddFailed, reminderFetchFailed, reminderAddFailed, notificationsResumeFailed
	
	var errorDescription: String? {
		return "Error"
	}
	
	var recoverySuggestion: String? {
		switch self {
		case .generic:
			return "Something went wrong..."
		case .plantFetchFailed:
			return "Failed to fetch plants..."
		case .plantEntryFetchFailed:
			return "Failed to fetch plant entries..."
		case .plantEntryAddFailed:
			return "Failed to add new plant entry..."
		case .teamFetchFailed:
			return "Failed to fetch teams..."
		case .userToTeamAddFailed:
			return "Failed to fetch teams..."
		case .teamCreationFailed:
			return "Failed to create a team..."
		case .userFetchFailed:
			return "Failed to fetch users..."
		case .eventFetchFailed:
			return "Failed to fetch events..."
		case .eventAddFailed:
			return "Failed to add new event..."
		case .reminderFetchFailed:
			return "Failed to fetch reminders..."
		case .reminderAddFailed:
			return "Failed to add new reminder..."
		case .notificationsResumeFailed:
			return "Failed to resume notifications..."
		}
	}
}

struct LocalizedAlertError: LocalizedError {
	let underlyingError: LocalizedError
	var errorDescription: String? {
		underlyingError.errorDescription
	}
	var recoverySuggestion: String? {
		underlyingError.recoverySuggestion
	}

	init?(error: Error?) {
		guard let localizedError = error else { return nil }
		underlyingError = localizedError
	}
}
