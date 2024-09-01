//
//  SubscribtionView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 31/08/2024.
//

import SwiftUI
import Firebase



struct SubscriptionView: View {
    @State private var currentRank: UserRank = .bronze
    @State private var isProcessing = false
    @State private var showSuccess = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Current Rank: \(currentRank.rawValue)")
                .font(.title)
                .padding()

            Button(action: {
                upgradeRank(to: .silver)
            }) {
                Text("Upgrade to Silver")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .disabled(currentRank != .bronze)

            Button(action: {
                upgradeRank(to: .gold)
            }) {
                Text("Upgrade to Gold")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
            }
            .disabled(currentRank == .gold)

            if isProcessing {
                ProgressView("Processing...")
                    .padding()
            }

            if showSuccess {
                Text("Successfully upgraded!")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .onAppear {
            // Fetch the current rank of the user
            fetchCurrentRank()
        }
    }

    private func upgradeRank(to rank: UserRank) {
        isProcessing = true
        SubscriptionManager.shared.upgradeUserRank(to: rank) { success in
            isProcessing = false
            if success {
                currentRank = rank
                showSuccess = true
            }
        }
    }

    private func fetchCurrentRank() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("Users").document(user.uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let rankString = document.data()?["rank"] as? String, let rank = UserRank(rawValue: rankString) {
                    self.currentRank = rank
                }
            }
        }
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
