//
//  Message.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable {
    var id: String
    var senderId: String
    var receiverId: String
    var content: String
    var timestamp: Date
    var isRead: Bool

    // To format the date for display purposes
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}

extension Message {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let senderId = dictionary["senderId"] as? String,
              let receiverId = dictionary["receiverId"] as? String,
              let content = dictionary["content"] as? String,
              let timestamp = dictionary["timestamp"] as? Timestamp else {
            return nil
        }

        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId
        self.content = content
        self.timestamp = timestamp.dateValue()
        self.isRead = dictionary["isRead"] as? Bool ?? false
    }
}



