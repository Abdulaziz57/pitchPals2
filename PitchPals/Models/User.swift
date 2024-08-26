//
//  User.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

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

    struct UserStatistics: Codable {
        var gamesPlayed: Int
        var gamesWon: Int
        var gamesLost: Int
        var totalGoals: Int
    }
}

extension User {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let username = dictionary["username"] as? String,
              let email = dictionary["email"] as? String,
              let firstName = dictionary["firstName"] as? String,
              let lastName = dictionary["lastName"] as? String,
              let profileImageUrl = dictionary["profileImageUrl"] as? String,
              let statisticsDict = dictionary["statistics"] as? [String: Int],
              let following = dictionary["following"] as? [String],
              let followers = dictionary["followers"] as? [String],
              let pastGames = dictionary["pastGames"] as? [String],
              let upcomingGames = dictionary["upcomingGames"] as? [String],
              let gamesPlayed = statisticsDict["gamesPlayed"],
              let gamesWon = statisticsDict["gamesWon"],
              let gamesLost = statisticsDict["gamesLost"],
              let totalGoals = statisticsDict["totalGoals"] else {
            return nil
        }
        
        self.id = id
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageUrl = profileImageUrl
        self.following = following
        self.followers = followers
        self.pastGames = pastGames
        self.upcomingGames = upcomingGames
        self.statistics = UserStatistics(gamesPlayed: gamesPlayed, gamesWon: gamesWon, gamesLost: gamesLost, totalGoals: totalGoals)
    }
}

extension User {
    func toDictionary() -> [String: Any] {
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
            "upcomingGames": upcomingGames
        ]
    }
}
