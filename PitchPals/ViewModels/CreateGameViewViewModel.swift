//
//  CreateGameViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

class CreateGameViewViewModel: ObservableObject {
    // Game properties
    @Published var name: String = ""
    @Published var time: String = ""
    @Published var location: String = ""
    @Published var host: String = ""
    @Published var tags: [String] = []
    @Published var price: String = ""
    @Published var organizer: String = ""
    @Published var organizerProfileImage: String = ""
    @Published var date: Date = Date() // Defaults to current date
    
    // Loading and error handling
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var networkManager = NetworkManager.shared
    
    // Validation and creation
    func validateAndCreateGame() {
        // Validate input
        guard !name.isEmpty, !time.isEmpty, !location.isEmpty, !host.isEmpty,
              !price.isEmpty, !organizer.isEmpty, !organizerProfileImage.isEmpty else {
            errorMessage = "Please make sure all fields are filled in."
            return
        }
        
        // Assuming price can be converted to a proper currency format if needed
        let game = Game(
            id: UUID().uuidString,
            name: name,
            time: time,
            location: location,
            host: host,
            tags: tags,
            price: price,
            organizer: organizer,
            organizerProfileImage: organizerProfileImage,
            date: date
        )
        
        createGame(game)
    }
    
    private func createGame(_ game: Game) {
        isLoading = true
        errorMessage = nil
        
        networkManager.createGame(game: game) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if success {
                    // Reset all fields after successful creation
                    self?.resetFields()
                }
            }
        }
    }
    
    private func resetFields() {
        name = ""
        time = ""
        location = ""
        host = ""
        tags = []
        price = ""
        organizer = ""
        organizerProfileImage = ""
        date = Date()
    }
}

