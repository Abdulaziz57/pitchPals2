//
//  Settings.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 06/04/2024.
//

import Foundation
import FirebaseFirestore

struct Settings: Codable {
    var isNotificationsEnabled: Bool
    var theme: String
    var language: String
    var allowLocationAccess: Bool
    var receiveNewsletter: Bool

    // Initialize with default values
    init(isNotificationsEnabled: Bool = true,
         theme: String = "Light",
         language: String = "English",
         allowLocationAccess: Bool = false,
         receiveNewsletter: Bool = true) {
        self.isNotificationsEnabled = isNotificationsEnabled
        self.theme = theme
        self.language = language
        self.allowLocationAccess = allowLocationAccess
        self.receiveNewsletter = receiveNewsletter
    }
}
