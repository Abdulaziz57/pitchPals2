//
//  SettingsViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation


import SwiftUI

class SettingsViewViewModel: ObservableObject {
    @Published var isNotificationsEnabled: Bool = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var networkManager = NetworkManager.shared
    private let userId: String

    init(userId: String) {
        self.userId = userId
        fetchSettings()
    }

    func fetchSettings() {
        isLoading = true
        // Fetch user settings from Firestore or other storage
        networkManager.fetchSettings(forUserId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let settings):
                    self?.isNotificationsEnabled = settings.isNotificationsEnabled
                    // Assign other settings as needed
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func updateSettings() {
        isLoading = true
        // Update settings in Firestore or other storage
        let updatedSettings = Settings(isNotificationsEnabled: isNotificationsEnabled)
        // Replace with actual update logic
        networkManager.updateSettings(forUserId: userId, settings: updatedSettings) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if success {
                    // Handle successful settings update
                }
            }
        }
    }
}
