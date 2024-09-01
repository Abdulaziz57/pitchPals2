import SwiftUI
import Firebase

struct MainContentView: View {
    let darkTextColor = Color.black
    let lightGrayColor = Color.gray.opacity(0.6)
    @State private var selectedTab: Int = 0
    @StateObject var venuesViewModel = VenuesViewModel()
    @State private var firstName: String = ""
    @State private var lastName: String = ""

    var body: some View {
        VStack {
            // Top bar with greeting and filter icon
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hello,")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(darkTextColor)

                    Text("\(firstName) \(lastName)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(darkTextColor)
                }

                Spacer()

                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 24))
                    .foregroundColor(darkTextColor)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)

            // Dynamic Venue filter buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(Set(venuesViewModel.venues.map { $0.name })), id: \.self) { venueName in
                        Button(action: {
                            // Handle filter action
                        }) {
                            Text(venueName)
                                .foregroundColor(darkTextColor)
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(darkTextColor, lineWidth: 1)
                                )
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)

            // Game cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image("dome") // Replace with your image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 180) // Adjusted size
                            .cornerRadius(20)

                        Text("Yellow theme Interior")
                            .font(.headline)
                            .foregroundColor(darkTextColor)

                        Text("Central Park")
                            .font(.subheadline)
                            .foregroundColor(lightGrayColor)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

                    VStack(alignment: .leading, spacing: 8) {
                        Image("maidan") // Replace with your image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 180) // Adjusted size
                            .cornerRadius(20)

                        Text("Gray theme Interior")
                            .font(.headline)
                            .foregroundColor(darkTextColor)

                        Text("Riverfront Stadium")
                            .font(.subheadline)
                            .foregroundColor(lightGrayColor)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)

            // Players Near You section
            VStack(alignment: .leading) {
                Text("Players Near You")
                    .font(.headline)
                    .foregroundColor(darkTextColor)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(0..<6) { _ in
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color.gray.opacity(0.4))
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 60)

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
            .background(Color.white.shadow(radius: 5))
            .background(Color.white)
            .cornerRadius(20)
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            venuesViewModel.fetchVenues()
            fetchUserName()
        }
        .navigationBarBackButtonHidden(true) // Hide the back button
    }

    // Function to fetch user's first and last name from Firestore
    func fetchUserName() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found")
            return
        }

        let db = Firestore.firestore()
        let docRef = db.collection("Users").document(userId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.firstName = data?["firstName"] as? String ?? "First Name"
                self.lastName = data?["lastName"] as? String ?? "Last Name"
                print("Fetched user data: \(self.firstName) \(self.lastName)")
            } else {
                print("User document does not exist")
            }
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
