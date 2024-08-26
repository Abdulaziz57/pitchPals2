//
//  UserListViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 06/04/2024.
//

import Foundation

import SwiftUI

class UserListViewViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var networkManager = NetworkManager.shared
    private let userId: String
    private let listType: UserListType
    
    enum UserListType {
        case followers, following
    }

    init(userId: String, listType: UserListType) {
        self.userId = userId
        self.listType = listType
        fetchUsers()
    }

    func fetchUsers() {
        isLoading = true
        errorMessage = nil

        let completion: (Result<[User], Error>) -> Void = { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let users):
                    self?.users = users
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
        
        switch listType {
        case .followers:
            networkManager.fetchFollowers(forUserId: userId, completion: completion)
        case .following:
            networkManager.fetchFollowing(forUserId: userId, completion: completion)
        }
    }
}
