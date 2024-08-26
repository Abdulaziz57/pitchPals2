//
//  PasswordChangeView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI
import FirebaseAuth

struct PasswordChangeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var showMessage: Bool = false
    @State private var message: String = ""
    @State private var showSignInView: Bool = false
    @State private var goBack: Bool = false
    let darkBlue = Color(red: 0, green: 0, blue: 0.8)
    @StateObject var viewModel = PasswordChangeViewModel() // ViewModel instance



    var body: some View {

        VStack {
            Spacer().frame(height: 1)

            Text("Forgot your password?")
                .font(.title)
                .fontWeight(.bold)

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
            .padding(.horizontal, 5)
            .padding(.bottom, 2)

            if viewModel.showMessage {
                Text(viewModel.message ?? "")
                    .foregroundColor(.red)
                    .padding()
            }
            
            

            Button(action: viewModel.resetPassword) {
                Text("Reset password")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(darkBlue)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
            .padding(.horizontal, 5)
            
            Divider()
                .background(Color.gray)
                .padding(.vertical)
            
            // 'Not a Pitch Pal yet?' text
            Text("Already a Pitch Pal?")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(.black)


            // 'Sign in' navigation link
            NavigationLink(destination: SignInView()) {
                Text("Sign in")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 5)


            // 'Go back' button
            Button("Go back") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .font(.headline)
            .foregroundColor(Color.black)
            .padding()

        }
        .padding()
        .navigationBarBackButtonHidden(true) // Optionally hide the back button
        .navigationTitle("")
        .navigationBarHidden(true)
    }

    private func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                message = error.localizedDescription
                showMessage = true
            } else {
                message = "Reset link sent to your email."
                showMessage = true
            }
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChangeView()
    }
}
