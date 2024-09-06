//
//  CreateGameView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI

struct CreateGameView: View {
    @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            NavigationView {
                VStack {
                    // Header with back button and title
                    HStack {
                        Button(action: {
                            // Action to go back
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .padding()
                                .background(Circle().fill(Color(.systemGray6)))
                        }

                        Spacer()
                        
                        Text("New Game")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        // This is a placeholder to balance the title position
                        Image(systemName: "chevron.left")
                            .foregroundColor(.clear)
                            .padding()
                    }
                    .padding(.horizontal)
                    
                    // Illustration
                    Image("footballer")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding(.top, 75)
                    
                    // Title "Pitch Booking"
                    Text("Pitch Booking")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 24)
                    
                    // Description
                    Text("Make sure you have arranged the pitch reservation directly with the venue. Pitch Palls does not reserve any pitches when you post a game.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 100)
                    
                    Spacer()
                    
                    // "Next" button
                    Button(action: {
                        // Action to go to the next screen
                    }) {
                        NavigationLink(destination: CreateGameView2()){
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                        }}
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
            
    .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    CreateGameView()
}
