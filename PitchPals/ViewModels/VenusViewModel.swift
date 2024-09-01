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
    private var didFetchVenues = false // This flag prevents duplicate fetches

    func fetchVenues() {
        guard !didFetchVenues else { return } // Skip fetching if already fetched
        didFetchVenues = true
        
        let db = Firestore.firestore()
        db.collection("Venues").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching venues: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            self.venues = documents.compactMap { queryDocumentSnapshot -> Venue? in
                let data = queryDocumentSnapshot.data()
                return Venue(id: queryDocumentSnapshot.documentID, dictionary: data)
            }
            
            print("Total venues fetched: \(self.venues.count)")
        }
    }
}
