//
//  GamesListViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI

class GamesListViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared

    init() {
        fetchGames()
    }

    func fetchGames() {
        isLoading = true
        errorMessage = nil

        networkManager.fetchGames { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
                    self?.games = games
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
