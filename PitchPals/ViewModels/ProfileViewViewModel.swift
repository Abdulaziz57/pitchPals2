//
//  ProfileViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

class ProfileViewViewModel: ObservableObject {
    @Published var user: User?
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
                    self?.user = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateUserProfile(with updatedData: [String: Any]) {
        isLoading = true
        networkManager.updateUserProfile(userId: userId, updatedData: updatedData) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if success {
                    self?.fetchUserProfile()  // Refresh user profile
                }
            }
        }
    }
}

