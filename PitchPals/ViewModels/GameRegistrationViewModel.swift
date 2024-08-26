//
//  GameRegistrationViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 06/04/2024.
//

import Foundation

import SwiftUI

class GameRegistrationViewModel: ObservableObject {
    @Published var availableGames: [Game] = []
    @Published var registeredGames: [Game] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var networkManager = NetworkManager.shared
    private let userId: String // The ID of the current user

    init(userId: String) {
        self.userId = userId
    }

    func fetchAvailableGames() {
        isLoading = true
        networkManager.fetchAvailableGames { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
                    self?.availableGames = games
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func joinGame(gameId: String) {
        isLoading = true
        networkManager.registerUserForGame(userId: userId, gameId: gameId) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if success {
                    // Update registeredGames list with the new game
                    // and update availableGames if needed
                    self?.fetchGameRegistrations()
                    self?.fetchAvailableGames()
                }
            }
        }
    }

    func fetchGameRegistrations() {
        isLoading = true
        networkManager.fetchUserRegisteredGames(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
                    self?.registeredGames = games
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // Add any other methods needed for game registration management
}

