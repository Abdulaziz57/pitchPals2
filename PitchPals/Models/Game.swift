//  Game.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Game: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var time: String
    var venueId: DocumentReference // Reference to the venue document in Firestore
    var date: Date
    var joinedPlayers: [String] = [] // Default to an empty array

    // Custom CodingKeys for Firestore fields
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case time
        case venueId
        case date
        case joinedPlayers
    }

    // Custom initializer for creating a new game
    init(name: String, time: String, venueId: DocumentReference, date: Date, joinedPlayers: [String] = []) {
        self.name = name
        self.time = time
        self.venueId = venueId
        self.date = date
        self.joinedPlayers = joinedPlayers
    }

    // Custom initializer for decoding from a Firestore document
    init?(document: [String: Any]) {
        guard let id = document["id"] as? String,
              let name = document["name"] as? String,
              let time = document["time"] as? String,
              let venueIdPath = document["venueId"] as? String,
              let date = document["date"] as? Timestamp,
              let joinedPlayers = document["joinedPlayers"] as? [String] else {
            return nil
        }
        self.id = id
        self.name = name
        self.time = time
        self.venueId = Firestore.firestore().document(venueIdPath)
        self.date = date.dateValue()
        self.joinedPlayers = joinedPlayers
    }

    // Custom encoding method for Firestore
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(time, forKey: .time)
        try container.encode(venueId.path, forKey: .venueId) // Convert DocumentReference to path
        try container.encode(date, forKey: .date)
        try container.encode(joinedPlayers, forKey: .joinedPlayers)
    }
}
