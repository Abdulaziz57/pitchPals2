//
//  VenueListViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

class VenueListViewViewModel: ObservableObject {
    @Published var venues: [Venue] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared

    func fetchVenues() {
        isLoading = true
        errorMessage = nil

        networkManager.fetchVenues { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedVenues):
                    self?.venues = fetchedVenues
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Add any additional functionality here, such as filtering or sorting venues
}
