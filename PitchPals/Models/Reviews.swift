//
//  Reviews.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 06/04/2024.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var itemId: String // Could be a gameId or venueId
    var content: String
    var timestamp: Date
    var rating: Int // Assuming a rating system out of 5
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case itemId
        case content
        case timestamp
        case rating
    }
}
