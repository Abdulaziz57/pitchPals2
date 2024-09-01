//
//  CreateGameView2.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 05/02/2024.
//

import SwiftUI

struct CreateGameView2: View {
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
                Image("soccer-player")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.top, 25)
                
                
                ScrollView {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Organiser's Policy")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.top, 18)
                                .padding(.bottom, 15)

        
                        // Using VStacks inside ScrollView for text
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("✅ Each player has to sign up and appear in the line-up")
                            }
                            .font(.body)
                            .padding(.bottom, 10)

                            HStack {

                                Text("🔗 Sharing your game link makes it super simple")
                            }
                            .font(.body)
                            .padding(.bottom, 10)


                            HStack {
                                Text("❌ Remember, if you don't stick to the Organiser's policy, your game might be called off")
                            }
                            .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                }



                Spacer()

                // "Got it!" button
                Button(action: {
                    // Action to go to the next screen
                }) {
                    NavigationLink(destination: CreateGameView3()){
                        
                        Text("Got it!")
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
            .navigationBarBackButtonHidden(true)
        }
    }
}
#Preview {
    CreateGameView2()
}
