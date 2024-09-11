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
            "pastGames": pastGames,
            "upcomingGames": upcomingGames,
            "rank": rank.rawValue  // Save the rank as a string

        ]
    }
}

extension User {
    init?(id: String, dictionary: [String: Any]) {
        guard let username = dictionary["username"] as? String,
              let email = dictionary["email"] as? String,
              let firstName = dictionary["firstName"] as? String,
              let lastName = dictionary["lastName"] as? String,
              let profileImageUrl = dictionary["profileImageUrl"] as? String,
              let statisticsDict = dictionary["statistics"] as? [String: Any],
              let gamesPlayed = statisticsDict["gamesPlayed"] as? Int,
              let gamesWon = statisticsDict["gamesWon"] as? Int,
              let gamesLost = statisticsDict["gamesLost"] as? Int,
              let totalGoals = statisticsDict["totalGoals"] as? Int,
              let pastGames = dictionary["pastGames"] as? [String],
              let upcomingGames = dictionary["upcomingGames"] as? [String],
              let rankString = dictionary["rank"] as? String,
              let rank = UserRank(rawValue: rankString) else {
            return nil
        }
        
        self.id = id
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageUrl = profileImageUrl
        self.statistics = UserStatistics(gamesPlayed: gamesPlayed, gamesWon: gamesWon, gamesLost: gamesLost, totalGoals: totalGoals)
        self.pastGames = pastGames
        self.upcomingGames = upcomingGames
        self.rank = rank
    }
        
    static var MOCK_USER = User(id: UUID().uuidString, username: "abdulaziz57", email: "a.mannai@hotmail.com", firstName: "abdulaziz", lastName: "al mannai", profileImageUrl: "String", statistics: UserStatistics(gamesPlayed: 0, gamesWon: 0, gamesLost: 0, totalGoals: 0), pastGames: ["String"], upcomingGames: ["String"], rank: .bronze)
}
