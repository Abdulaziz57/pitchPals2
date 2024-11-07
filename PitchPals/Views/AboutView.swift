//
//  AboutView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI

//
//  AboutView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About Us")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Welcome to PitchPals, the ultimate platform for football enthusiasts to find, join, and organize games. Our mission is to make it easier for players of all levels to connect and enjoy the beautiful game.")
                .font(.body)
                .padding(.horizontal)
            
            Text("Features")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            Text("""
            - User-friendly interface to browse and join games
            - Comprehensive venue management for available locations
            - Real-time updates on game status
            - Personalized chatbot tips for improving your skills
            - Secure subscription plans for exclusive features
            """)
                .font(.body)
                .padding(.horizontal)
            
            Text("Contact Us")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            Text("If you have any questions, feel free to reach out to us at support@pitchpals.com.")
                .font(.body)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AboutView()
}
