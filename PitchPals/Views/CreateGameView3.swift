//
//  GamesListView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//
import SwiftUI
import Firebase

struct CreateGameView3: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var gameName: String = ""
    @State private var selectedVenueId: String = ""
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()

    @StateObject var venuesViewModel = VenuesViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Game Details")) {
                    TextField("Game Name", text: $gameName)
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }

                Section(header: Text("Select Venue")) {
                    Picker("Venue", selection: $selectedVenueId) {
                        ForEach(venuesViewModel.venues, id: \.id) { venue in
                            Text(venue.name).tag(venue.id ?? "")
                        }
                    }
                }
            }
            .navigationTitle("Create Game")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                createGame()
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                venuesViewModel.fetchVenues()
            }
        }
    }

    private func createGame() {
        guard !gameName.isEmpty, !selectedVenueId.isEmpty else { return }

        let venueRef = Firestore.firestore().collection("Venues").document(selectedVenueId)
        let game = Game(name: gameName, time: formatTime(selectedTime), venueId: venueRef, date: selectedDate)
        saveGameToFirestore(game)
    }

    private func saveGameToFirestore(_ game: Game) {
        let db = Firestore.firestore()
        do {
            let _ = try db.collection("Games").document(game.id!).setData(from: game)
            print("Game created successfully")
        } catch let error {
            print("Error writing game to Firestore: \(error)")
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    CreateGameView3()
}
