//
//  MainViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import Combine

class MainContentViewModel: ObservableObject {
    @Published var upcomingGames: [Game] = [] // Placeholder for game data
    @Published var notifications: [Notification] = [] // Adjust based on your notification structure

    // Services or managers
    private var networkManager = NetworkManager.shared // Assuming you have a network manager that handles data fetching
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // You might want to fetch initial data here or you could call these methods from the view's onAppear.
        fetchUpcomingGames()
        fetchNotifications()
    }
    
    func fetchUpcomingGames() {
        networkManager.fetchUpcomingGames { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let games):
                    self?.upcomingGames = games
                case .failure(let error):
                    // Handle the error
                    print("Error fetching games: \(error)")
                }
            }
        }
    }
    
    func fetchNotifications() {
        networkManager.fetchNotifications { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let notifications):
                    self?.notifications = notifications
                case .failure(let error):
                    print("Error occurred: \(error)")
                    // Handle the error appropriately
                }
            }
        }
    }

    
    func hostNewGame() {
        // Logic for hosting a new game
        // This could show a modal or navigate to a different view for creating a game
    }
    
    // Add any other actions or data fetching methods your view needs to interact with the backend.
}
