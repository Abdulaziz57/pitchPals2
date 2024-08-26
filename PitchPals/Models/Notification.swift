//
//  Notification.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import FirebaseFirestore

struct Notification: Identifiable, Codable {
    var id: String
    var title: String
    var message: String
    var timestamp: Date
    var isRead: Bool
    // Add other properties as needed

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let title = dictionary["title"] as? String,
              let message = dictionary["message"] as? String,
              let timestamp = dictionary["timestamp"] as? Timestamp,
              let isRead = dictionary["isRead"] as? Bool else {
            return nil
        }

        self.id = id
        self.title = title
        self.message = message
        self.timestamp = timestamp.dateValue()  // Converting Timestamp to Date
        self.isRead = isRead
        // Initialize other properties as needed
    }
}
