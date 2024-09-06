//
//  HomeView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 24/01/2024.
//


import SwiftUI
import AuthenticationServices
import Firebase
import GoogleSignIn



struct HomeView: View {
    // Add the navigation trigger state
    @State private var showSignInView = false
    @State private var showSignUpView = false

    
    var body: some View {
        
        ZStack {
            // Background Image
            Image("Background-Image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            // Overlay to dim the background image
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)

            // Main content
            VStack {
                Spacer()
                
                // Logo placeholder
                Image("football")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                
                // Name Text
                Text("Pitch Pals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .shadow(radius: 400)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 15)


                // Welcome Text
                Text("Join us and play football games whenever you want")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 376)
                    .padding(.bottom, 7)

                
                Button(action: {
                    showSignInView = true
                }) {
                    Text("Sign in")
                        .underline()
                        .fontWeight(.semibold)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(.top, 30)
                .padding(.bottom, 30)

                // The actual NavigationLink that listens to the showSignInView state
                NavigationLink(destination: SignInView(), isActive: $showSignInView) {
                    EmptyView()
                }
                .hidden()

                Button(action: {
                    showSignUpView = true
                }){
                    Text("Create an account for free")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: 2)
                )
                .padding(.horizontal, 385)
                
                // The actual NavigationLink that listens to the showSignInView state
                NavigationLink(destination: SignUpView(), isActive: $showSignUpView) {
                    EmptyView()
                }
                .hidden()
                
                
                .padding()
                
                .padding(.bottom, 20)
                .overlay(
                    Rectangle()
                        .frame(width: 355, height: 2)
                        .foregroundColor(.white), alignment: .bottom
                )
                
                // Legal Text
                Text("By signing up, you agree to our Terms and Conditions, Privacy Policy, and Cookie Policy")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 400)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                Spacer()
                
            }
            
            .navigationBarHidden(true)  // Ensure the navigation bar is hidden

        }
        
    }
    
    
}


// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 15 Pro")
    }
}



