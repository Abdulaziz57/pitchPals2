//
//  SignInViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation
import FirebaseAuth
import SwiftUI

class SignInViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false  // To control navigation on successful sign-in

    var onSignInSuccess: (() -> Void)?

    func signIn() {
        isLoading = true
        errorMessage = nil

        // Check if the input fields are not empty
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            isLoading = false
            return
        }

        // Perform sign-in with Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Failed to sign in: \(error.localizedDescription)"
                } else if authResult != nil {
                    // Sign-in successful
                    self?.isAuthenticated = true
                    self?.onSignInSuccess?()  // Notify the view that sign-in was successful
                } else {
                    self?.errorMessage = "Unknown error occurred."
                }
            }
        }
    }
}

