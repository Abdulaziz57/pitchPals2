//
//  MessagesListviewViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import Foundation

import SwiftUI

class MessagesListViewViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared

    func fetchMessages() {
        isLoading = true
        errorMessage = nil

        networkManager.fetchMessages { [weak self] (result: Result<[Message], Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedMessages):
                    self?.messages = fetchedMessages
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


