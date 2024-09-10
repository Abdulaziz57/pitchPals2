//
//  GameDetailView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//
import SwiftUI
import FirebaseFirestore

struct GameDetailView: View {
    let game: Game
    let venue: Venue
    
    @Environment(\.presentationMode) var presentationMode

    
    @State private var joinedPlayers: [User] = []  // List of players who joined the game
    @State private var isJoined = false
    @State private var isWaitlisted = false
    @State private var user = User.MOCK_USER // Assume the logged-in user
    @State private var waitlist: [String] = [] // List of waitlisted users

    var body: some View {
        ScrollView {
            
            VStack(spacing: 0) {
                // Full-width image at the top
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: URL(string: venue.pictureUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill() // Ensures the image covers the full width
                            .frame(height: 250) // Adjust height as needed
                            .clipped() // Ensures the image doesn’t overflow
                    } placeholder: {
                        ProgressView()
                            .frame(height: 250)
                    }
                    
                    // Circular Back Button on top of the image
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Circle().fill(Color.white))
                            .shadow(radius: 5)
                    }
                    .padding(.leading, 16) // Align back button to the left
                    .padding(.top, 16)     // Align back button to the top
                }
                
                
                // Game details card
                VStack(spacing: 15) {
                    // Game Title
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(formattedDate(game.date)) @\(venue.name)")
                                .font(.title2)
                                .bold()
                                .padding(.bottom, 10)
                            
                            Text("\(venue.pitchSize) a side by @\(user.username)")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    
                    Rectangle()
                        .frame(height: 0.4)
                        .foregroundColor(Color.gray)
                        .padding(.horizontal, 10)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    
                    
                    
                    // Game info
                    HStack {
                        Image(systemName: "calendar")
                        Text("\(formattedDate(game.date))")
                            .font(.headline)
                        
                        Spacer()
                        
                    }
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(venue.location)
                            .font(.headline)
                        Spacer()
                            .padding(.bottom, 35)
                        
                    }
                    
                    // Player count
                    HStack {
                        Text("\(joinedPlayers.count) attending")
                            .font(.subheadline)
                        Spacer()
                    }
                    
                    // List of joined players (avatars)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(joinedPlayers, id: \.id) { player in
                                playerAvatarView(for: player)
                            }
                        }
                    }
                    
                    // Game Description and Rules
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Game Rules")
                            .font(.headline)
                        Text("""
                        • 2 hour game
                        • Be on time 10-15 minutes before kickoff
                        • Bring 50 to pay the keepers
                        • Anyone who gets late 15 minutes will get a warning
                        • No shouting, No aggressive behavior
                        """)
                        .font(.body)
                        .foregroundColor(.gray)
                        
                        Text("Venue: \(venue.name)")
                            .font(.subheadline)
                            .padding(.top, 10)
                    }
                    .padding(.vertical)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                .offset(y: -30)
                
                Spacer()
                
                // Action buttons
                // Update the action buttons section
                Button(action: {
                    if isJoined {
                        leaveGame()
                    } else {
                        joinGame()
                    }
                }) {
                    Text(isJoined ? "Leave" : "Join")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isJoined ? Color.red : Color.blue)
                        .cornerRadius(10)
                }
                
                .padding(.horizontal)
                .padding(.bottom, 10)
                
            }
            .onAppear {
                loadPlayers()
                checkIfUserJoined()
                loadWaitlist()
            }
            // Hide the back button
        }
        .navigationBarBackButtonHidden(true) 
    }
    
    // MARK: - Subviews
    
    private func playerAvatarView(for player: User) -> some View {
        VStack {
            AsyncImage(url: URL(string: player.profileImageUrl)) { image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            Text(player.username)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
    
    // MARK: - Helper Methods
    
    func loadPlayers() {
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        
        for playerId in game.joinedPlayers {
            usersCollection.document(playerId).getDocument { (snapshot, error) in
                guard let data = snapshot?.data() else { return }
                if let player = User(id: playerId, dictionary: data) {
                    DispatchQueue.main.async {
                        self.joinedPlayers.append(player)
                    }
                }
            }
        }
    }
    
    func checkIfUserJoined() {
        isJoined = game.joinedPlayers.contains(user.id)
    }

    
    func loadWaitlist() {
        let db = Firestore.firestore()
        let gameRef = db.collection("Games").document(game.id ?? "")
        
        gameRef.getDocument { document, error in
            if let document = document, document.exists {
                if let waitlist = document.data()?["waitlist"] as? [String] {
                    self.waitlist = waitlist
                    isWaitlisted = waitlist.contains(user.id)
                }
            }
        }
    }
    
    func joinGame() {
        print("Attempting to join game...")
        
        let db = Firestore.firestore()
        
        if joinedPlayers.count < Int(venue.pitchSize) ?? 0 {
            db.collection("Games").document(game.id ?? "").updateData([
                "joinedPlayers": FieldValue.arrayUnion([user.id])
            ]) { error in
                if let error = error {
                    print("Error joining game: \(error)")
                } else {
                    isJoined = true
                    joinedPlayers.append(user)
                    print("User joined game")
                }
            }
        } else {
            print("Game full, adding to waitlist")
            addToWaitlist()
        }
    }



    func leaveGame() {
        let db = Firestore.firestore()
        
        db.collection("Games").document(game.id ?? "").updateData([
            "joinedPlayers": FieldValue.arrayRemove([user.id])
        ]) { error in
            if let error = error {
                print("Error leaving game: \(error)")
            } else {
                if let index = joinedPlayers.firstIndex(where: { $0.id == user.id }) {
                    joinedPlayers.remove(at: index)
                }
                isJoined = false
            }
        }
    }

    func addToWaitlist() {
        let db = Firestore.firestore()
        db.collection("Games").document(game.id ?? "").updateData([
            "waitlist": FieldValue.arrayUnion([user.id])
        ]) { error in
            if let error = error {
                print("Error adding to waitlist: \(error)")
            } else {
                isWaitlisted = true
            }
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    
    
}

// MARK: - Preview
struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockVenue = Venue(
            id: UUID().uuidString,
            name: "PitchPals Football Field",
            location: "Doha, Qatar",
            pictureUrl: "https://example.com/venue.png",
            pitchSize: "10"
        )
        
        let mockGame = Game(
            name: "Friendly Match",
            time: "10:00 AM",
            venueId: Firestore.firestore().document("Venues/\(UUID().uuidString)"),
            date: Date(), maxPlayers: 12,
            joinedPlayers: [User.MOCK_USER.id]
        )
        
        return GameDetailView(game: mockGame, venue: mockVenue)
    }
}
