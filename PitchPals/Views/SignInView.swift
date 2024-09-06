//
//  SignInView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//
import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = SignInViewViewModel()
    @State private var navigateToMainContent = false

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 0)
                
                Text("Sign in")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                    .fontWeight(.bold)
                    .padding(.bottom, 15)

                // Email field
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    TextField("Email address", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
                .padding(.bottom, 5)

                // Password field
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.password)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)

                // Error message if any
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                }
                
                NavigationLink(destination: PasswordChangeView()) {
                    Text("Did you forget your password?")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                        .foregroundColor(Color.gray)
                }

                // Sign In Button
                Button("Sign in") {
                    viewModel.signIn()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                // Navigation to MainContentView
                NavigationLink(destination: MainContentView(), isActive: $navigateToMainContent) {
                    EmptyView() // Invisible navigation link for programmatic navigation
                }.hidden()
                
                Divider()
                    .background(Color.gray)
                    .padding(.vertical)
                    .padding(.horizontal, 24)

                // 'Not a Pitch Pal yet?' text
                Text("Not a Pitch Pal yet?")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                    .padding(.top, 15)

                // Create an account for free
                NavigationLink(destination: SignUpView()) {
                    Text("Create an account for free")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 0.7)
                        )
                }
                .padding(.horizontal, 24)

                // 'Go back' button
                Button("Go back") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                .font(.subheadline)
                .foregroundColor(Color.black)
                .fontWeight(.regular)
                .padding(.top, 10)
            }
            .padding(.top) // Adjust as needed to match the design

        }
        .onAppear {
            viewModel.onSignInSuccess = {
                self.navigateToMainContent = true
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarHidden(true) 
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
