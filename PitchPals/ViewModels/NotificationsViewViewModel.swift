//
//  NotificationsViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

class NotificationsViewViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared

    func fetchNotifications() {
        isLoading = true
        networkManager.fetchNotifications { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedNotifications):
                    self?.notifications = fetchedNotifications
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func markNotificationAsRead(notificationId: String) {
        // Update notification's read status in the database
        // This functionality depends on how you've structured notifications in Firestore
    }
}
