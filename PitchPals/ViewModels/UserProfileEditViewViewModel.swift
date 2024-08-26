//
//  UserProfileEditViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

class UserProfileEditViewViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var bio: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var networkManager = NetworkManager.shared
    private let userId: String

    init(userId: String) {
        self.userId = userId
        fetchUserProfile()
    }

    func fetchUserProfile() {
        isLoading = true
        networkManager.fetchUser(with: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.username = user.username
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateUserProfile() {
        isLoading = true
        let updatedData: [String: Any] = ["username": username, "bio": bio]
        networkManager.updateUserProfile(userId: userId, updatedData: updatedData) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if success {
                    // Profile updated successfully
                    // Additional actions after successful update can be added here
                }
            }
        }
    }
}

