//
//  FollowersListViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

class FollowersListViewViewModel: ObservableObject {
    @Published var followers: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared
    private let userId: String

    init(userId: String) {
        self.userId = userId
        fetchFollowers()
    }

    func fetchFollowers() {
        isLoading = true
        networkManager.fetchFollowers(forUserId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedFollowers):
                    self?.followers = fetchedFollowers
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

