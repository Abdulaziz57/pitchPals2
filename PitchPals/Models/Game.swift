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
    var venueId: DocumentReference
    var date: Date
    var maxPlayers: Int
    var joinedPlayers: [String] = [] // List of player IDs who joined the game
    var waitlist: [String] = []      // Queue of players on the waitlist

    // Custom CodingKeys for Firestore fields
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case time
        case venueId
        case date
        case joinedPlayers
        case waitlist
        case maxPlayers
    }

    // Custom initializer for creating a new game
    init(name: String, time: String, venueId: DocumentReference, date: Date, maxPlayers: Int, joinedPlayers: [String] = [], waitlist: [String] = []) {
        self.name = name
        self.time = time
        self.venueId = venueId
        self.date = date
        self.maxPlayers = maxPlayers
        self.joinedPlayers = joinedPlayers
        self.waitlist = waitlist
    }

    // Custom initializer for decoding from a Firestore document
    init?(document: [String: Any]) {
        guard let id = document["id"] as? String,
              let name = document["name"] as? String,
              let time = document["time"] as? String,
              let venueIdPath = document["venueId"] as? String,
              let date = document["date"] as? Timestamp,
              let joinedPlayers = document["joinedPlayers"] as? [String],
              let waitlist = document["waitlist"] as? [String],
              let maxPlayers = document["maxPlayers"] as? Int else {
            return nil
        }
        self.id = id
        self.name = name
        self.time = time
        self.venueId = Firestore.firestore().document(venueIdPath)
        self.date = date.dateValue()
        self.joinedPlayers = joinedPlayers
        self.waitlist = waitlist
        self.maxPlayers = maxPlayers
    }

    // Custom encoding method for Firestore
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(time, forKey: .time)
        try container.encode(venueId.path, forKey: .venueId)
        try container.encode(date, forKey: .date)
        try container.encode(joinedPlayers, forKey: .joinedPlayers)
        try container.encode(waitlist, forKey: .waitlist) // Encode waitlist
        try container.encode(maxPlayers, forKey: .maxPlayers)
    }
}
