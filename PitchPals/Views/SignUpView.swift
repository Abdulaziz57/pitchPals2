//
//  SignUpView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var viewModel = SignUpViewController() // ViewModel instance

    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var errorMessage: String? = nil
    @State private var isShowingAlert = false

    var body: some View {
        VStack {
            Text("Join Pitch Pals")
                .padding(.bottom, 1)
                .padding(.top, 10)
                .font(.largeTitle)
                .fontWeight(.bold)



            Text("Only a few clicks away from your next football game")
                .font(.subheadline)
                .fontWeight(.regular)
                .padding(.bottom, 15)
                .foregroundColor(.gray)

            // Username field
            HStack {
                Image(systemName: "at")
                    .foregroundColor(.gray)
                TextField("Username", text: $viewModel.username)
                    .textContentType(.username)
            }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 1)
                .padding(.horizontal, 10)


            // Email field
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.bottom, 1)
            .padding(.horizontal, 10)




            // Password field
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.bottom, 1)
            .padding(.horizontal, 10)


            // First Name field
            TextField("First Name", text: $viewModel.firstName)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 1)
                .padding(.horizontal, 10)




            // Last Name field
            TextField("Last Name", text: $viewModel.lastName)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 5)
                .padding(.horizontal, 10)


            // Sign Up Button
            Button("Sign up") {
                viewModel.signUp()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .fontWeight(.semibold)
            .background(Color.black)
            .cornerRadius(10)
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
            
            NavigationLink(destination: MainContentView(), isActive: $viewModel.isSignUpSuccessful) { EmptyView() }
            .hidden()


            Text("By signing up, you agree to our Terms and conditions Privacy Policy and Cookie Policy")
                .font(.footnote)
                .padding(.horizontal, 40)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray)
                .padding(.horizontal, 10)
                .padding(.top, 10)

            // Already a member prompt
            Text("Already a Pitch Pal?")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top, 10)


            // 'Sign in' navigation link
            NavigationLink(destination: SignInView()) {
                Text("Sign in")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            


            // Go Back Button
            Button("Go back") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(Color.black)
            .padding(.top, 10)


        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .navigationBarHidden(true)
    }
    
 
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

