//
//  MessageDetailViewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

class MessageDetailViewViewModel: ObservableObject {
    @Published var message: Message?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var replyText: String = ""
    
    private var networkManager = NetworkManager.shared
    private let messageId: String

    init(messageId: String) {
        self.messageId = messageId
        fetchMessageDetails()
    }

    func fetchMessageDetails() {
        isLoading = true
        networkManager.fetchMessageDetail(with: messageId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedMessage):
                    self?.message = fetchedMessage
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func sendMessageReply() {
        guard !replyText.isEmpty else { return }
        
        // Implement your logic to send a message reply
        // This can include updating the message thread with the new reply
        // and communicating with the NetworkManager
    }
}

