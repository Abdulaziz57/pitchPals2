//
//  AuthenticationViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//



import SwiftUI
import Firebase

class AuthenticationViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        // Observe the authentication state
        Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = user != nil
        }
    }
    
    // Function to log out
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}


