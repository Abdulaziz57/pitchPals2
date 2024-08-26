//
//  UserStatistics.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 06/04/2024.
//

import Foundation

struct UserStatistics: Codable {
    var gamesPlayed: Int
    var gamesWon: Int
    var gamesLost: Int
    var totalGoals: Int
    
    init(gamesPlayed: Int = 0, gamesWon: Int = 0, gamesLost: Int = 0, totalGoals: Int = 0) {
        self.gamesPlayed = gamesPlayed
        self.gamesWon = gamesWon
        self.gamesLost = gamesLost
        self.totalGoals = totalGoals
    }
    
    init(dictionary: [String: Any]) {
        self.gamesPlayed = dictionary["gamesPlayed"] as? Int ?? 0
        self.gamesWon = dictionary["gamesWon"] as? Int ?? 0
        self.gamesLost = dictionary["gamesLost"] as? Int ?? 0
        self.totalGoals = dictionary["totalGoals"] as? Int ?? 0
    }
}

