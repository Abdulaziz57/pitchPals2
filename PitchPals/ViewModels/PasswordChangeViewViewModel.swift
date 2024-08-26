//
//  PasswordChangeViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

// PasswordChangeViewModel.swift

import SwiftUI
import FirebaseAuth

class PasswordChangeViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading = false
    @Published var message: String?
    @Published var showMessage = false

    func resetPassword() {
        guard !email.isEmpty, email.contains("@"), email.contains(".") else {
            message = "Please enter a valid email address."
            showMessage = true
            return
        }

        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.message = error.localizedDescription
                } else {
                    self?.message = "Reset link sent to your email."
                }
                self?.showMessage = true
            }
        }
    }
}
