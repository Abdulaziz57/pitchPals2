//
//  Venue.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

struct Venue: Identifiable, Codable {
    var id: String
    var name: String
    var location: String
    var facilities: [String]
    var description: String
    var images: [String] // URLs of venue images
    var availableSlots: [VenueSlot]

    struct VenueSlot: Codable, Identifiable {
        var id: String // Unique identifier for the slot
        var date: Date
        var startTime: Date
        var endTime: Date
        var price: Double
        var isBooked: Bool
    }
}

extension Venue {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let location = dictionary["location"] as? String,
              let facilities = dictionary["facilities"] as? [String],
              let description = dictionary["description"] as? String,
              let images = dictionary["images"] as? [String],
              let slotsArray = dictionary["availableSlots"] as? [[String: Any]] else {
            return nil
        }

        var availableSlots = [VenueSlot]()
        for slotDict in slotsArray {
            if let slot = VenueSlot(dictionary: slotDict) {
                availableSlots.append(slot)
            }
        }

        self.id = id
        self.name = name
        self.location = location
        self.facilities = facilities
        self.description = description
        self.images = images
        self.availableSlots = availableSlots
    }
}

extension Venue.VenueSlot {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let date = dictionary["date"] as? Date,
              let startTime = dictionary["startTime"] as? Date,
              let endTime = dictionary["endTime"] as? Date,
              let price = dictionary["price"] as? Double,
              let isBooked = dictionary["isBooked"] as? Bool else {
            return nil
        }

        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.price = price
        self.isBooked = isBooked
    }
}

