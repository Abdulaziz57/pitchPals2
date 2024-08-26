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
    var location: String
    var host: String
    var tags: [String]
    var price: String
    var organizer: String
    var organizerProfileImage: String
    var date: Date
}

// Sample data for previewing
extension Game {
    static var sampleData: [Game] {
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        // Use the date formatter to create Date objects
        guard let date1 = dateFormatter.date(from: "11/02/2024"),
              let date2 = dateFormatter.date(from: "11/02/2024") else {
            fatalError("Date format is incorrect or dates are invalid")
        }

        // Return the sample data array
        return [
            Game(id: "1", name: "Paradise Park, Highbury", time: "11:00 AM", location: "London, UK", host: "@stephen-howell", tags: ["#highbury", "#northlondon"], price: "£7.50", organizer: "Ali", organizerProfileImage: "Profile-Image", date: date1),
            Game(id: "2", name: "Archbishops Park, Waterloo", time: "12:00 PM", location: "London, UK", host: "@zackbarina", tags: ["#waterloo", "#centrallondon"], price: "£7.50", organizer: "Abdulaziz", organizerProfileImage: "Profile-Image", date: date2)
        ]
    }
}

extension Game {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let time = dictionary["time"] as? String,
              let location = dictionary["location"] as? String,
              let host = dictionary["host"] as? String,
              let tags = dictionary["tags"] as? [String],
              let price = dictionary["price"] as? String,
              let organizer = dictionary["organizer"] as? String,
              let organizerProfileImage = dictionary["organizerProfileImage"] as? String,
              let date = dictionary["date"] as? Date else {
            return nil
        }
        self.id = id
        self.name = name
        self.time = time
        self.location = location
        self.host = host
        self.tags = tags
        self.price = price
        self.organizer = organizer
        self.organizerProfileImage = organizerProfileImage
        self.date = date
    }
}

extension Game {
    func toDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        
        // If you're using dates, you need to set the date encoding strategy
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

