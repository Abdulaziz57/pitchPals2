//
//  GamesListView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI
import Firebase

struct CreateGameView3: View {
    @State private var navigateToSearchView = false // Add state for navigation
    @State private var gameName: String = ""
    @State private var selectedVenueId: String = ""
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var maxPlayers: String = ""
    
    @StateObject var venuesViewModel = VenuesViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Game Details Form
                VStack(spacing: 16) {
                    TextField("Enter Game Name", text: $gameName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    DatePicker("Select Game Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding(.horizontal)

                    DatePicker("Select Game Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding(.horizontal)

                    TextField("Max Players", text: $maxPlayers)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                // Venue Picker
                VStack(alignment: .leading) {
                    Text("Select Venue")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if venuesViewModel.venues.isEmpty {
                        Text("No venues available")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        Picker("Venue", selection: $selectedVenueId) {
                            ForEach(venuesViewModel.venues, id: \.id) { venue in
                                Text(venue.name).tag(venue.id)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // Save Game Button
                Button(action: {
                    createGame()
                    navigateToSearchView = true // Trigger navigation to SearchView
                }) {
                    Text("Save Game")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.black : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(!isFormValid)
                .padding(.bottom, 20)
                
                // Navigation to SearchView after Save or Cancel
                NavigationLink(destination: SearchView(), isActive: $navigateToSearchView) {
                    EmptyView() // Invisible navigation link for programmatic navigation
                }.hidden()
            }
            .navigationTitle("Create Game")
            .navigationBarItems(leading: Button("Cancel") {
                navigateToSearchView = true // Navigate back to SearchView when Cancel is pressed
            })
            .onAppear {
                venuesViewModel.fetchVenues()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // Helper Methods for Validation
    private var isFormValid: Bool {
        return !gameName.isEmpty && !selectedVenueId.isEmpty && Int(maxPlayers) != nil
    }

    // Helper Method to Create Game
    private func createGame() {
        guard isFormValid, let maxPlayersInt = Int(maxPlayers) else {
            print("Invalid input")
            return
        }

        let venueRef = Firestore.firestore().collection("Venues").document(selectedVenueId)
        let game = Game(
            name: gameName,
            time: formatTime(selectedTime),
            venueId: venueRef,
            date: selectedDate,
            maxPlayers: maxPlayersInt
        )
        saveGameToFirestore(game)
    }

    // Save Game to Firestore
    private func saveGameToFirestore(_ game: Game) {
        let db = Firestore.firestore()
        do {
            let _ = try db.collection("Games").document(game.id!).setData(from: game)
            print("Game created successfully")
        } catch let error {
            print("Error writing game to Firestore: \(error)")
        }
    }

    // Format Time for Display
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    CreateGameView3()
}
