//
//  SignInViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

class SignInViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false  // To control navigation on successful sign-in

    private var networkManager = NetworkManager.shared

    var onSignInSuccess: (() -> Void)?

    func signIn() {
        isLoading = true
        errorMessage = nil

        networkManager.signIn(email: email, password: password) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if success {
                    self?.onSignInSuccess?()
                }
            }
        }
    }
}
