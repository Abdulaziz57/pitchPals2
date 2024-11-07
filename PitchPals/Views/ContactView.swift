//
//  MessageDetailView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//


import SwiftUI

struct ContactView: View {
    @State private var message: String = ""
    @State private var email: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Contact Us")
                .font(.largeTitle)
                .padding(.top)
            
            Text("We'd love to hear from you! Send us a message and we'll get back to you as soon as possible.")
                .font(.body)
                .padding(.horizontal)
            
            TextField("Your email address", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .keyboardType(.emailAddress)
            
            TextEditor(text: $message)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .frame(height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            Button(action: sendMessage) {
                Text("Send")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Message Sent"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func sendMessage() {
        guard !message.isEmpty && !email.isEmpty else {
            alertMessage = "Please enter your email and message."
            showingAlert = true
            return
        }

        // Placeholder code for sending an email.
        // In a production app, call a backend API to handle the email sending.
        alertMessage = "Thank you! Your message has been sent."
        showingAlert = true
        message = ""
        email = ""
    }
}

#Preview {
    ContactView()
}
