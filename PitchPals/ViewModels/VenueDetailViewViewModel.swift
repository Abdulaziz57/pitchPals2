//
//  VenueDetailViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

class VenueDetailViewViewModel: ObservableObject {
    @Published var venue: Venue
    @Published var isLoading = false
    @Published var errorMessage: String?
    // Add additional properties related to venue details or actions

    private var networkManager = NetworkManager.shared

    init(venueId: String) {
        self.venue = Venue(id: venueId, name: "", location: "", facilities: [], description: "", images: [], availableSlots: [])
        fetchVenueDetails(venueId: venueId)
    }

    func fetchVenueDetails(venueId: String) {
        isLoading = true
        networkManager.fetchVenueDetails(venueId: venueId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedVenue):
                    self?.venue = fetchedVenue
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // Implement other functionalities like booking a slot, adding reviews, etc.
}

