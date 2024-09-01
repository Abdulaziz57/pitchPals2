//
//  User.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation
import FirebaseAuth

enum UserRank: String, Codable {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
}

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var profileImageUrl: String
    var statistics: UserStatistics
    var following: [String] // User IDs of people the user is following
    var followers: [String] // User IDs of followers
    var pastGames: [String] // Game IDs of past games
    var upcomingGames: [String] // Game IDs of upcoming games
    var rank: UserRank = .bronze  // Default rank is Bronze

    

    struct UserStatistics: Codable {
        var gamesPlayed: Int
        var gamesWon: Int
        var gamesLost: Int
        var totalGoals: Int
    }
    
    // Computed property to convert User to a dictionary
    var dictionary: [String: Any] {
        return [
            "id": id,
            "username": username,
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "profileImageUrl": profileImageUrl,
            "statistics": [
                "gamesPlayed": statistics.gamesPlayed,
                "gamesWon": statistics.gamesWon,
                "gamesLost": statistics.gamesLost,
                "totalGoals": statistics.totalGoals
            ],
            "following": following,
            "followers": followers,
            "pastGames": pastGames,
            "upcomingGames": upcomingGames,
            "rank": rank.rawValue  // Save the rank as a string

        ]
    }
}

extension User {
    static var MOCK_USER = User(id: UUID().uuidString, username: "abdulaziz57", email: "a.mannai@hotmail.com", firstName: "abdulaziz", lastName: "al mannai", profileImageUrl: "String", statistics: UserStatistics(gamesPlayed: 0, gamesWon: 0, gamesLost: 0, totalGoals: 0), following: ["String"], followers: ["String"], pastGames: ["String"], upcomingGames: ["String"], rank: .bronze)
}
