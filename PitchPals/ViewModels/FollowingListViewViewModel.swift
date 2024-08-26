//
//  FollowingListViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI


class FollowingListViewViewModel: ObservableObject {
    @Published var following: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared
    private let userId: String

    init(userId: String) {
        self.userId = userId
        fetchFollowing()
    }

    func fetchFollowing() {
        isLoading = true
        networkManager.fetchFollowing(forUserId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedFollowing):
                    self?.following = fetchedFollowing
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
