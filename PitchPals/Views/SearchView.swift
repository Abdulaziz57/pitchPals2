//  SearchView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// MARK: - SearchView
struct SearchView: View {
    let darkTextColor = Color.black
    let lightGrayColor = Color.gray.opacity(0.6)
    
    @State private var searchText: String = ""
    @State private var games: [Game] = []
    @State private var venues: [Venue] = []
    @State private var currentUser: User? // Store the logged-in user

    @State private var users: [User] = [] // Store all users for profile images and names
    
    var filteredGames: [Game] {
        searchText.isEmpty ? games : games.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            fetchVenueName(for: $0).localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar
                if filteredGames.isEmpty {
                    emptyStateView
                } else {
                    gamesListView
                }
                Spacer()
                tabBar
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Search Games")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let user = currentUser {
                        if user.rank == .gold { // Only show if user rank is Gold
                            addGameButton
                        } else {
                            Text("Rank: \(user.rank.rawValue)") // Debugging output
                        }
                    } else {
                        Text("User not loaded") // If currentUser is nil, show this
                    }
                }
            }
            .onAppear(perform: {
                loadData()
                fetchCurrentUser()  // Fetch the current user from Firestore
            })
        }
        .navigationBarBackButtonHidden(true) // Hide the back button
    }
    
    // MARK: - Subviews
    
    private var searchBar: some View {
        HStack {
            TextField("Search by name or location", text: $searchText)
                .padding(.leading, 20)
                .frame(height: 45)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.trailing, 20)
                    }
                )
                .padding(.horizontal)
        }
        .padding(.top, 16)
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("No games found.")
                .font(.headline)
                .foregroundColor(lightGrayColor)
            Text("Try a different search.")
                .font(.subheadline)
                .foregroundColor(lightGrayColor)
            Spacer()
        }
        .padding()
    }
    
    private var gamesListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                ForEach(filteredGames) { game in
                    gameCard(for: game)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
    
    private func gameCard(for game: Game) -> some View {
        Group {
            if let venue = fetchVenue(for: game) {
                NavigationLink(destination: GameDetailView(game: game, venue: venue)) {
                    VStack(alignment: .leading, spacing: 12) {
                        AsyncImage(url: URL(string: venue.pictureUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .cornerRadius(12)
                        } placeholder: {
                            ProgressView()
                                .frame(height: 200)
                        }
                        
                        Text(game.name)
                            .font(.headline)
                            .foregroundColor(darkTextColor)

                        Text(venue.name)
                            .font(.subheadline)
                            .foregroundColor(lightGrayColor)

                        gameInfoRow(for: game, venue: venue)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                }
            }
        }
    }


    private func gameInfoRow(for game: Game, venue: Venue) -> some View {
        HStack {
            Text("Date: \(formattedDate(game.date))")
                .font(.caption)
                .foregroundColor(lightGrayColor)
            Spacer()
            // Replace venue.pitchSize with game.maxPlayers
            Text("\(game.joinedPlayers.count)/\(game.maxPlayers) Players")
                .font(.caption)
                .foregroundColor(lightGrayColor)
        }
        .padding(.top, 4)
    }

    
    private func joinedPlayersSection(for game: Game) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Players Joined:")
                .font(.headline)
            
            if game.joinedPlayers.isEmpty {
                Text("No players joined yet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                ForEach(game.joinedPlayers, id: \.self) { playerId in
                    if let player = fetchUser(for: playerId) {
                        HStack {
                            AsyncImage(url: URL(string: player.profileImageUrl)) { image in
                                image.resizable().frame(width: 40, height: 40).clipShape(Circle())
                            } placeholder: {
                                Circle().frame(width: 40, height: 40).foregroundColor(.gray)
                            }
                            Text(player.username)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .padding(.top)
    }
    
    private var addGameButton: some View {
        NavigationLink(destination: CreateGameView()) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(darkTextColor)
        }
    }
    
    private var tabBar: some View {
        HStack {
            Spacer()
            NavigationLink(destination: MainContentView()) {
                Image(systemName: "house.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
            }
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 28))
                .foregroundColor(darkTextColor)
            Spacer()
            NavigationLink(destination: ChatbotView()) {
                Image(systemName: "message.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
            }
            Spacer()
            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
            }
            Spacer()
        }
        .background(Color.white.shadow(radius: 5))
        .background(Color.white)
        .cornerRadius(20)
        .navigationBarBackButtonHidden(true)
        .padding(.top, 10)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // MARK: - Data Handling
    
    func loadData() {
        let db = Firestore.firestore()
        
        // Fetch Venues
        db.collection("Venues").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching venues: \(error)")
                return
            }
            if let documents = snapshot?.documents {
                venues = documents.compactMap { Venue(id: $0.documentID, dictionary: $0.data()) }
            }
        }
        
        // Fetch Games
        db.collection("Games").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching games: \(error)")
                return
            }
            if let documents = snapshot?.documents {
                games = documents.compactMap { Game(document: $0.data()) }
            }
        }
        
        // Fetch Users
        db.collection("Users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }
            if let documents = snapshot?.documents {
                users = documents.compactMap { User(id: $0.documentID, dictionary: $0.data()) }
            }
        }
    }
    
    func fetchVenue(for game: Game) -> Venue? {
        venues.first { $0.id == game.venueId.documentID }
    }
    
    func fetchCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found")
            return
        }

        let db = Firestore.firestore()
        let docRef = db.collection("Users").document(userId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let userData = document.data() {
                    self.currentUser = User(id: userId, dictionary: userData)
                    print("Fetched user data: \(self.currentUser?.rank.rawValue ?? "Unknown rank")")
                }
            } else {
                print("User document does not exist")
            }
        }
    }

    func fetchVenueName(for game: Game) -> String {
        fetchVenue(for: game)?.name ?? ""
    }
    
    func fetchUser(for playerId: String) -> User? {
        users.first { $0.id == playerId }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - SearchView_Previews
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
