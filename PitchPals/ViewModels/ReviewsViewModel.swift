//
//  ReviewsViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 06/04/2024.
//

import Foundation
import Firebase


import SwiftUI

class ReviewsViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var newReviewText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared
    private let itemId: String // This could be a gameId or venueId
    private let reviewType: ReviewType // For game reviews or venue reviews
    
    enum ReviewType {
        case game, venue
    }

    init(itemId: String, reviewType: ReviewType) {
        self.itemId = itemId
        self.reviewType = reviewType
        fetchReviews()
    }

    func fetchReviews() {
        isLoading = true
        networkManager.fetchReviews(forItemId: itemId, reviewType: reviewType) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedReviews):
                    self?.reviews = fetchedReviews
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func submitReview() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            errorMessage = "User must be logged in."
            return
        }

        guard !newReviewText.isEmpty else {
            errorMessage = "Review text cannot be empty."
            return
        }
        
        isLoading = true

        let review = Review(userId: currentUserId,
                            itemId: itemId,
                            content: newReviewText,
                            timestamp: Date(),
                            rating: 5) // Replace with actual rating if you have a rating system

        // Now use this review object to submit to NetworkManager
        networkManager.submitReview(review, reviewType: reviewType) { [weak self] success, error in
            // ... handle the result
        }
    }
}
