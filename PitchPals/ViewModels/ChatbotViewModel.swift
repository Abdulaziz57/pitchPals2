//
//  ChatBotViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 01/09/2024.
//

import SwiftUI
import Combine

class ChatbotViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false  // Add this property

    func sendMessage(_ content: String) {
        let userMessage = ChatMessage(id: UUID().uuidString, content: content, isUser: true)
        messages.append(userMessage)

        // Set isLoading to true when the request starts
        isLoading = true

        ApiCaller.shared.sendMessage(prompt: content) { [weak self] response in
            DispatchQueue.main.async {
                // Set isLoading to false when the request completes
                self?.isLoading = false
                
                if let responseText = response {
                    let botMessage = ChatMessage(id: UUID().uuidString, content: responseText, isUser: false)
                    self?.messages.append(botMessage)
                } else {
                    let errorMessage = ChatMessage(id: UUID().uuidString, content: "Sorry, I couldn't process your request.", isUser: false)
                    self?.messages.append(errorMessage)
                }
            }
        }
    }
}


