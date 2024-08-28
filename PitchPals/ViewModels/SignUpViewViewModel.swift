//
//  SignUpViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class SignUpViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSignUpSuccessful = false

    private var db = Firestore.firestore()

    func signUp() {
        isLoading = true
        errorMessage = nil
        
        print("SignUp method called") // Add this line

        // Validate inputs as needed
        guard !email.isEmpty, !password.isEmpty, !username.isEmpty else {
            errorMessage = "Please fill in all fields."
            isLoading = false
            print("Validation failed: All fields are not filled in") // Add this line
            return
        }

        // Perform the sign up operation
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = "Failed to sign up: \(error.localizedDescription)"
                self.isLoading = false
                print("Error creating user: \(error.localizedDescription)") // Add this line
                return
            }
            
            guard let user = authResult?.user else {
                self.errorMessage = "Failed to retrieve user information."
                self.isLoading = false
                print("Error: authResult user is nil") // Add this line
                return
            }
            
            // User created successfully
            self.isSignUpSuccessful = true
            print("SignUp successful") // Add this line
            
            // Save user details in Firestore
            let userData = User(id: user.uid, username: self.username, email: self.email, firstName: self.firstName, lastName: self.lastName, profileImageUrl: "Profile-Image-URL", statistics: User.UserStatistics(gamesPlayed: 0, gamesWon: 0, gamesLost: 0, totalGoals: 0), following: [], followers: [], pastGames: [], upcomingGames: [])
            
            Firestore.firestore().collection("Users").document(user.uid).setData(userData.dictionary) { error in
                if let error = error {
                    self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                    print("Error saving user data: \(error.localizedDescription)") // Add this line
                } else {
                    print("User data saved successfully") // Add this line
                }
                self.isLoading = false
            }
        }
    }

}
