//
//  AuthViewModel.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 06.06.2022.
//

import Foundation
import FirebaseAuth

final class AuthViewModel: ObservableObject {
	@Published var isSignInViewDisplayed = true
	@Published var isProcessing = false
	@Published var errorMessage = ""
	@Published var signInEmail = ""
	@Published var signInPassword = ""
	@Published var signUpEmail = ""
	@Published var signUpPassword = ""
	@Published var signUpPasswordConfirmation = ""
	
	func signInUser() {
		errorMessage = ""
		isProcessing = true
		
		Auth.auth().signIn(withEmail: signInEmail, password: signInPassword) { authResult, error in
			guard error == nil else {
				self.isProcessing = false
				self.errorMessage = error!.localizedDescription
				return
			}
			
			let authUserEmail = authResult?.user.email ?? ""
			print("User signed in \(authUserEmail) ")
			self.isProcessing = false
		}
	}
	
	func signUpUser() {
		errorMessage = ""
		isProcessing = true
		
		if (signUpPassword != signUpPasswordConfirmation) {
			errorMessage = "Passwords do not match."
			isProcessing = false
			return
		}
		Auth.auth().createUser(withEmail: signUpEmail, password: signUpPassword) { authResult, error in
			guard error == nil else {
				self.isProcessing = false
				self.errorMessage = error!.localizedDescription
				return
			}
			
			let authUserEmail = authResult?.user.email ?? ""
			print("User signed up \(authUserEmail) ")
			self.isProcessing = false
		}
	}
	
	func toggleSignIn() {
		isSignInViewDisplayed = !isSignInViewDisplayed
	}
}
