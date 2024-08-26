//
//  SearchViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var gameResults: [Game] = []
    @Published var venueResults: [Venue] = []
    @Published var userResults: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared

    init() {}

    func search() {
        guard !query.isEmpty else {
            clearResults()
            return
        }

        isLoading = true
        // Ideally, you'd want to combine these into a single network call,
        // but for demonstration, these are split into separate calls.
        networkManager.searchGames(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleResult(result, update: &self!.gameResults)
            }
        }

        networkManager.searchVenues(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleResult(result, update: &self!.venueResults)
            }
        }

        networkManager.searchUsers(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleResult(result, update: &self!.userResults)
                self?.isLoading = false // Set this when the last call completes
            }
        }
    }

    private func handleResult<T>(_ result: Result<[T], Error>, update resultsArray: inout [T]) {
        switch result {
        case .success(let results):
            resultsArray = results
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }

    func clearResults() {
        gameResults = []
        venueResults = []
        userResults = []
    }
}

