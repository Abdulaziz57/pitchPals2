//
//  Profile View.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    let darkTextColor = Color.black
    @State private var phone: String = "(123) 456-7890"
    @State private var profileImageUrl: String = ""
    @State private var gamesPlayed: Int = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) { // Added spacing for cleaner layout
                // Profile Header Section
                HStack(spacing: 30) { // Horizontal arrangement for profile picture and text
                    // Profile Image
                    if let url = URL(string: profileImageUrl), !profileImageUrl.isEmpty {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        }
                    } else {
                        // Default image
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .foregroundColor(.black)
                    }
                    
                    VStack(alignment: .leading) { // Profile information on the right of the image
                        Text(username)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Text("Fotball Player") // Example placeholder for the role
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        
                    }
                    Spacer()
                }
                

                
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                
                Rectangle()
                    .frame(height: 0.4)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 10)

                // Games Played Section (with cleaner layout)
                VStack {
                    Text("\(gamesPlayed)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("Games Played")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                Rectangle()
                    .frame(height: 0.4)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 10)

                // List of Actions Section
                VStack(spacing: 15) {
                    ProfileActionButton(icon: "person", title: "Profile", destination: ProfileDetailView())
                    ProfileActionButton(icon: "gearshape", title: "Settings", destination: SettingsView())
                    ProfileActionButton(icon: "creditcard", title: "Subscription", destination: SubscriptionView())
                    ProfileActionButton(icon: "info.circle", title: "About", destination: AboutView())
                    ProfileActionButton(icon: "phone", title: "Contact", destination: ContactView())
                }
                .padding(.horizontal)

                Spacer()
                
                Rectangle()
                    .frame(height: 0.4)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 10)
                
                // Log Out Button
                Button(action: {
                    logOut()
                }) {
                    HStack {
                        Image(systemName: "power")
                            .foregroundColor(.red) // Same color as the text
                        Text("Log out")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        Spacer() // Ensures the text and icon remain on the left
                    }
                    .padding()
                    .background(Color.white) // Background color of the button (optional)
                    .cornerRadius(10) // Rounded edges (optional)
                }
                .padding(.horizontal) // Padding on the sides for better spacing
                .padding(.bottom, 50)


                // Custom Tab Bar
                customTabBar
            }
            .onAppear {
                fetchUserProfile()
            }
            .navigationBarHidden(true) // Remove the top navigation bar
        }
        .navigationBarHidden(true) // Remove the top navigation bar

    }

    // Action button helper
    struct ProfileActionButton<Destination: View>: View {
        var icon: String
        var title: String
        var destination: Destination

        var body: some View {
            NavigationLink(destination: destination) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.black)
                        .font(.headline)
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
        }
    }

    // Custom Bottom Tab Bar
    private var customTabBar: some View {
        // Custom tab bar with navigation
        HStack {
            Spacer()
            NavigationLink(destination: MainContentView()) {
                Image(systemName: "house.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
            }
            Spacer()
            NavigationLink(destination: SearchView()) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
            }
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
        .padding(.vertical, 12)
        .background(Color.white.shadow(radius: 5))
        .cornerRadius(20)
        .padding(.bottom, 25)
        .padding(.horizontal, 10)
        .navigationBarHidden(true) // Remove the top navigation bar

    }

    // Function to fetch user's profile information from Firestore
    func fetchUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found")
            return
        }

        let db = Firestore.firestore()
        let docRef = db.collection("Users").document(userId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.username = data?["username"] as? String ?? "username"
                self.email = data?["email"] as? String ?? "example@example.com"
                self.phone = data?["phone"] as? String ?? "(123) 456-7890"
                self.profileImageUrl = data?["profileImageUrl"] as? String ?? ""
                if let statistics = data?["statistics"] as? [String: Any] {
                    self.gamesPlayed = statistics["gamesPlayed"] as? Int ?? 0
                }
                print("Fetched user data: \(self.username)")
            } else {
                print("User document does not exist")
            }
        }
    }

    // Function to log out
    func logOut() {
        do {
            try Auth.auth().signOut()
            // Redirect to login page or handle post-logout UI
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    

}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
