//
//  Venue.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//
struct Venue: Identifiable, Codable {
    var id: String
    var name: String
    var location: String
    var pictureUrl: String // URL or name of the venue image
    var pitchSize: String // Number of players that can play on the pitch
}

extension Venue {
    init?(id: String, dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let location = dictionary["location"] as? String,
              let pictureUrl = dictionary["pictureUrl"] as? String,
              let pitchSize = dictionary["pitchSize"] as? String else {
            return nil
        }

        self.id = id
        self.name = name
        self.location = location
        self.pictureUrl = pictureUrl
        self.pitchSize = pitchSize
    }
}
