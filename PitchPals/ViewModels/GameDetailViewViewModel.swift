//
//  GameDetailViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import Foundation

class GameDetailViewViewModel: ObservableObject {
    @Published var game: Game?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var networkManager = NetworkManager.shared
    
    func fetchGameDetails(gameId: String) {
        isLoading = true
        errorMessage = nil
        
        networkManager.fetchGame(with: gameId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let gameDetails):
                    self?.game = gameDetails
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                self?.isLoading = false
            }
        }
    }
}

