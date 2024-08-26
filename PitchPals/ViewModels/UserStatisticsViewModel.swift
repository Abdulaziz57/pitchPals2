//
//  UserStatisticsViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 06/04/2024.
//

import Foundation

class UserStatisticsViewModel: ObservableObject {
    @Published var statistics: UserStatistics
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared
    private let userId: String

    init(userId: String) {
        self.userId = userId
        self.statistics = UserStatistics() // Initialize with default values
        fetchUserStatistics()
    }

    func fetchUserStatistics() {
        isLoading = true
        networkManager.fetchUserStatistics(forUserId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let stats):
                    self?.statistics = stats
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

}

