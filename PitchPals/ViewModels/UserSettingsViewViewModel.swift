//
//  UserSettingsViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 06/04/2024.
//

import Foundation

import SwiftUI

class UserSettingsViewViewModel: ObservableObject {
    @Published var userSettings: Settings
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared
    private let userId: String

    init(userId: String) {
        self.userId = userId
        self.userSettings = Settings()
        fetchUserSettings()
    }

    func fetchUserSettings() {
        isLoading = true
        networkManager.fetchUserSettings(forUserId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let settings):
                    self?.userSettings = settings
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func updateUserSettings() {
        isLoading = true
        networkManager.updateUserSettings(forUserId: userId, settings: userSettings) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if success {
                    // Update local settings and handle post-update logic
                }
            }
        }
    }
}
