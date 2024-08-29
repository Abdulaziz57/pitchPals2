//  Game.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

struct Game: Identifiable, Codable {
    var id: String
    var name: String
    var time: String
    var venueId: String // Link to the venue
    var date: Date
    var joinedPlayers: [String] // List of user IDs who have joined the game

    init(id: String = UUID().uuidString, name: String, time: String, venueId: String, date: Date, joinedPlayers: [String] = []) {
        self.id = id
        self.name = name
        self.time = time
        self.venueId = venueId
        self.date = date
        self.joinedPlayers = joinedPlayers
    }
}

extension Game {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let time = dictionary["time"] as? String,
              let venueId = dictionary["venueId"] as? String,
              let date = dictionary["date"] as? Date,
              let joinedPlayers = dictionary["joinedPlayers"] as? [String] else {
            return nil
        }
        self.id = id
        self.name = name
        self.time = time
        self.venueId = venueId
        self.date = date
        self.joinedPlayers = joinedPlayers
    }
}

extension Game {
    func toDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to dictionary"])
        }
        return dictionary
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
