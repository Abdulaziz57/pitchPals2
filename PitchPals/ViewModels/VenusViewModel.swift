//
//  VenueDetailViewModel.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import FirebaseFirestore

@MainActor
class VenuesViewModel: ObservableObject {
    @Published var venues: [Venue] = []

    init() {
        print("VenuesViewModel initialized")
        fetchVenues()
    }

    func fetchVenues() {
        print("Fetching venues from Firestore...")
        let db = Firestore.firestore()

        db.collection("Venues").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching venues: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No venues found.")
                return
            }

            print("Snapshot found: \(documents.count) documents")
            for document in documents {
                print("Document data: \(document.data())")
                let id = document.documentID
                if let venue = Venue(id: id, dictionary: document.data()) {
                    self.venues.append(venue)
                } else {
                    print("Error parsing venue: The data couldn’t be read because it is missing.")
                }
            }
            
            print("Total venues fetched: \(self.venues.count)")
        }
    }

}

