//
//  NetworkManager.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 30/01/2024.
//

import Foundation
import Firebase




class NetworkManager {
    
    static let shared = NetworkManager()
    let db = Firestore.firestore()
    
    func fetchGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        db.collection("games").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let querySnapshot = querySnapshot {
                var games: [Game] = []
                for document in querySnapshot.documents {
                    // Convert document data to Game object
                    let data = document.data()
                    if let game = Game(dictionary: data) {
                        games.append(game)
                    }
                }
                completion(.success(games))
            }
        }
    }

    
    func fetchGame(with gameId: String, completion: @escaping (Result<Game, Error>) -> Void) {
        let gameRef = db.collection("games").document(gameId)
        
        gameRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                // Assuming `Game` conforms to `Codable`
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dataDescription, options: [])
                    let gameDetails = try JSONDecoder().decode(Game.self, from: jsonData)
                    completion(.success(gameDetails))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "PitchPals", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
            }
        }
    }
    

    
    func createGame(game: Game, completion: @escaping (Bool, Error?) -> Void) {
        do {
            let gameData = try game.toDictionary()
            db.collection("games").addDocument(data: gameData) { error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        } catch let error {
            completion(false, error)
        }
    }


    func updateGame(gameId: String, updatedData: [String: Any]) {
        db.collection("games").document(gameId).updateData(updatedData) { error in
            if let error = error {
                print("Error updating game: \(error)")
            } else {
                print("Game successfully updated")
            }
        }
    }

    func deleteGame(gameId: String) {
        db.collection("games").document(gameId).delete() { error in
            if let error = error {
                print("Error deleting game: \(error)")
            } else {
                print("Game successfully deleted")
            }
        }
    }
    




    private func createUserProfile(userId: String, username: String, email: String, completion: @escaping (Bool, Error?) -> Void) {
        db.collection("users").document(userId).setData([
            "username": username,
            "email": email
            // Add other user properties as needed
        ]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)  // Sign-in successful
            }
        }
    }
    
    func fetchMessageDetail(with messageId: String, completion: @escaping (Result<Message, Error>) -> Void) {
        // Fetch a single message logic here
        // Example using Firestore:
        Firestore.firestore().collection("messages").document(messageId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists, let message = try? document.data(as: Message.self) {
                completion(.success(message))
            } else {
                completion(.failure(NSError(domain: "MessageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Message not found"])))
            }
        }
    }
    
    func fetchMessages(completion: @escaping (Result<[Message], Error>) -> Void) {
        // Your code to fetch messages goes here
        // Example using Firestore:
        Firestore.firestore().collection("messages").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let messages = snapshot?.documents.compactMap { document -> Message? in
                    try? document.data(as: Message.self)
                }
                completion(.success(messages ?? []))
            }
        }
    }
    
    class AuthenticationState: ObservableObject {
        @Published var isAuthenticated = false
    }

    // In your App or Scene delegate
    let authState = AuthenticationState()



    func fetchUser(with userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data(), let user = User(dictionary: data) else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                    return
                }
                completion(.success(user))
            } else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: nil)))
            }
        }
    }

    func updateUserProfile(userId: String, updatedData: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
        db.collection("users").document(userId).updateData(updatedData) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func fetchNotifications(completion: @escaping (Result<[Notification], Error>) -> Void) {
        // Replace with your actual fetching logic
        Firestore.firestore().collection("notifications").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var notifications = [Notification]()
                snapshot?.documents.forEach { document in
                    if let notification = try? document.data(as: Notification.self) {
                        notifications.append(notification)
                    }
                }
                completion(.success(notifications))
            }
        }
    }
    
    
    func fetchFollowers(forUserId userId: String, completion: @escaping (Result<[User], Error>) -> Void) {
        // Assuming followers are stored under a user's document
        let followersRef = db.collection("users").document(userId).collection("followers")
        
        followersRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var followers: [User] = []
                for document in querySnapshot!.documents {
                    if let follower = User(dictionary: document.data()) {
                        followers.append(follower)
                    }
                }
                completion(.success(followers))
            }
        }
    }
    
    func fetchFollowing(forUserId userId: String, completion: @escaping (Result<[User], Error>) -> Void) {
        // Assuming 'following' are stored under a user's document
        let followingRef = db.collection("users").document(userId).collection("following")
        
        followingRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var followingUsers: [User] = []
                for document in querySnapshot!.documents {
                    if let user = User(dictionary: document.data()) {
                        followingUsers.append(user)
                    }
                }
                completion(.success(followingUsers))
            }
        }
    }
    
    func fetchSettings(forUserId userId: String, completion: @escaping (Result<Settings, Error>) -> Void) {
        let settingsRef = db.collection("users").document(userId).collection("settings").document("userSettings")

        settingsRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists, let data = document.data() {
                do {
                    // Convert dictionary to JSON data then decode to Settings object
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let settings = try JSONDecoder().decode(Settings.self, from: jsonData)
                    completion(.success(settings))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Settings document does not exist"])))
            }
        }
    }

    func updateSettings(forUserId userId: String, settings: Settings, completion: @escaping (Bool, Error?) -> Void) {
         let settingsRef = db.collection("users").document(userId).collection("settings").document("userSettings")

         do {
             // Convert Settings object to JSON data then to dictionary
             let jsonData = try JSONEncoder().encode(settings)
             guard let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
                 throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error converting JSON to Dictionary"])
             }

             settingsRef.setData(dictionary) { error in
                 if let error = error {
                     completion(false, error)
                 } else {
                     completion(true, nil)
                 }
             }
         } catch let error {
             completion(false, error)
         }
     }
    
    func fetchUserSettings(forUserId userId: String, completion: @escaping (Result<Settings, Error>) -> Void) {
        let settingsRef = db.collection("users").document(userId).collection("settings").document("userSettings")

        settingsRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                do {
                    // Assuming Settings conforms to Codable
                    let settings = try document.data(as: Settings.self)
                    completion(.success(settings))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Settings not found"])))
            }
        }
    }
    
    func updateUserSettings(forUserId userId: String, settings: Settings, completion: @escaping (Bool, Error?) -> Void) {
        let settingsRef = db.collection("users").document(userId).collection("settings").document("userSettings")

        do {
            // Assuming Settings conforms to Codable
            try settingsRef.setData(from: settings) { error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        } catch let error {
            completion(false, error)
        }
    }
    
    func fetchVenues(completion: @escaping (Result<[Venue], Error>) -> Void) {
        db.collection("venues").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var venues = [Venue]()
                for document in querySnapshot!.documents {
                    if let venue = Venue(dictionary: document.data()) {
                        venues.append(venue)
                    }
                }
                completion(.success(venues))
            }
        }
    }

    func updateVenue(venueId: String, updatedData: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
        let venueRef = db.collection("venues").document(venueId)

        venueRef.updateData(updatedData) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func fetchUserStatistics(forUserId userId: String, completion: @escaping (Result<UserStatistics, Error>) -> Void) {
        // Fetch user statistics logic here
        // Example using Firestore:
        Firestore.firestore().collection("userStatistics").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists, let stats = try? document.data(as: UserStatistics.self) {
                completion(.success(stats))
            } else {
                completion(.failure(NSError(domain: "UserStatisticsError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Statistics not found"])))
            }
        }
    }
    
    func searchGames(query: String, completion: @escaping (Result<[Game], Error>) -> Void) {
        db.collection("games")
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let games = querySnapshot?.documents.compactMap { document -> Game? in
                        try? document.data(as: Game.self)
                    }
                    completion(.success(games ?? []))
                }
            }
    }

    func searchVenues(query: String, completion: @escaping (Result<[Venue], Error>) -> Void) {
        db.collection("venues")
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let venues = querySnapshot?.documents.compactMap { document -> Venue? in
                        try? document.data(as: Venue.self)
                    }
                    completion(.success(venues ?? []))
                }
            }
    }
    
    func searchUsers(query: String, completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: query)
            .whereField("username", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let users = querySnapshot?.documents.compactMap { document -> User? in
                        try? document.data(as: User.self)
                    }
                    completion(.success(users ?? []))
                }
            }
    }
    
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Bool, Error?) -> Void) {
        // Assuming user is already authenticated and current user is available
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"]))
            return
        }

        // Reauthenticate user with current password
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(false, error)
            } else {
                // Update to new password
                user.updatePassword(to: newPassword) { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    func fetchVenueDetails(venueId: String, completion: @escaping (Result<Venue, Error>) -> Void) {
        let venueRef = db.collection("venues").document(venueId)

        venueRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = documentSnapshot, document.exists {
                guard let venue = Venue(dictionary: document.data() ?? [:]) else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error parsing venue details"])))
                    return
                }
                completion(.success(venue))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Venue not found"])))
            }
        }
    }
    
    func fetchAvailableGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        db.collection("games").whereField("isBooked", isEqualTo: false).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let games = querySnapshot?.documents.compactMap { document -> Game? in
                    try? document.data(as: Game.self)
                }
                completion(.success(games ?? []))
            }
        }
    }

    func registerUserForGame(userId: String, gameId: String, completion: @escaping (Bool, Error?) -> Void) {
        // Reference to the specific game
        let gameRef = db.collection("games").document(gameId)

        // Begin a write batch
        let batch = db.batch()
        
        // Update the game's 'isBooked' field or the field that tracks player registrations
        batch.updateData(["isBooked": true], forDocument: gameRef)

        // Optionally: Add the game to the user's 'registeredGames' collection
        let userGameRef = db.collection("users").document(userId).collection("registeredGames").document(gameId)
        batch.setData(["gameId": gameId, "registeredDate": Timestamp(date: Date())], forDocument: userGameRef)

        // Commit the batch
        batch.commit { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }

    func fetchUserRegisteredGames(userId: String, completion: @escaping (Result<[Game], Error>) -> Void) {
        db.collection("users").document(userId).collection("registeredGames").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var registeredGames: [Game] = []
                
                // Assuming 'registeredGames' documents have a 'gameId' field
                let group = DispatchGroup()
                for document in querySnapshot!.documents {
                    group.enter()
                    let gameId = document.data()["gameId"] as? String ?? ""
                    let gameRef = self.db.collection("games").document(gameId)
                    
                    gameRef.getDocument { gameSnapshot, error in
                        if let gameSnapshot = gameSnapshot, gameSnapshot.exists {
                            if let game = try? gameSnapshot.data(as: Game.self) {
                                registeredGames.append(game)
                            }
                        }
                        group.leave()
                    }
                }
                
                // When all the game documents have been fetched
                group.notify(queue: .main) {
                    completion(.success(registeredGames))
                }
            }
        }
    }
    
    func fetchReviews(forItemId itemId: String, reviewType: ReviewsViewModel.ReviewType, completion: @escaping (Result<[Review], Error>) -> Void) {
        let collectionPath = reviewType == .game ? "games" : "venues"
        db.collection(collectionPath).document(itemId).collection("reviews").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let reviews = querySnapshot?.documents.compactMap { document -> Review? in
                    try? document.data(as: Review.self)
                }
                completion(.success(reviews ?? []))
            }
        }
    }

    func submitReview(_ review: Review, reviewType: ReviewsViewModel.ReviewType, completion: @escaping (Bool, Error?) -> Void) {
        let collectionPath = reviewType == .game ? "games" : "venues"
        let reviewRef = db.collection(collectionPath).document(review.itemId).collection("reviews").document()
        
        do {
            try reviewRef.setData(from: review)
            completion(true, nil)
        } catch let error {
            completion(false, error)
        }
    }
    
    func fetchUpcomingGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        // Fetch games logic here
        // For example, if you are fetching from Firebase Firestore:
        let gamesCollection = Firestore.firestore().collection("games")
        gamesCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let games = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Game.self)
                }
                completion(.success(games ?? []))
            }
        }
    }
    
    
    
    

 }





    

