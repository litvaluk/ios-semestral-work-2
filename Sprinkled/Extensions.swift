//
//  Extensions.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 18.06.2022.
//

import SwiftUI

extension Color {
	static let sprinkledGreen = Color("SprinkledGreen")
	static let sprinkledPaleGreen = Color("SprinkledPaleGreen")
	static let sprinkledGray = Color("SprinkledGray")
}

extension View {
	func errorAlert(error: Binding<Error?>, buttonTitle: String = "Ok") -> some View {
		let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
		return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
			Button(buttonTitle) {
				error.wrappedValue = nil
			}
		} message: { error in
			Text(error.recoverySuggestion ?? "")
		}
	}
}
