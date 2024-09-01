//
//  ChatbotView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 28/08/2024.
//

import SwiftUI

struct ChatbotView: View {
    var body: some View {
        VStack {
            Text("Ask me anything about football!")
                .font(.title)
                .padding()
            
            Spacer()
            
            // Placeholder for chatbot interface
            Text("Chatbot interface goes here")
                .foregroundColor(.gray)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Football Chatbot")
    }
}

struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}

