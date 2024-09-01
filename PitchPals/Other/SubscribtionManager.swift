//
//  SubscribtionManager.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 31/08/2024.
//

import Foundation

import FirebaseFirestore
import FirebaseAuth

class SubscriptionManager {
    static let shared = SubscriptionManager()
    private let db = Firestore.firestore()

    func upgradeUserRank(to rank: UserRank, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        db.collection("Users").document(userId).updateData(["rank": rank.rawValue]) { error in
            if let error = error {
                print("Error upgrading rank: \(error)")
                completion(false)
            } else {
                print("Successfully upgraded to \(rank.rawValue)")
                completion(true)
            }
        }
    }
}
