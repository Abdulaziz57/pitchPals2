//
//  ChatbotView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 28/08/2024.
//
import SwiftUI

struct ChatbotView: View {
    @ObservedObject var viewModel = ChatbotViewModel()
    @State private var userInput: String = ""

    let darkTextColor = Color.black
    let lightGrayColor = Color.gray.opacity(0.6)
    let userMessageBackgroundColor = Color.blue
    let botMessageBackgroundColor = Color(.systemGray5)

    var body: some View {
        VStack(spacing: 0) {
            chatTitleBar
            chatMessagesScrollView
            Divider()
            chatInputBar
            if viewModel.isLoading {
                ProgressView("Loading...")  // Show a loading indicator
                    .padding()
            }
            customTabBar
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews

    private var chatTitleBar: some View {
        HStack {
            Spacer()
            Text("Football Chatbot")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(darkTextColor)
                .padding(.vertical, 12)
            Spacer()
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }

    private var chatMessagesScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.messages) { message in
                    chatBubble(for: message)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
        .background(Color.white)
    }

    private func chatBubble(for message: ChatMessage) -> some View {
        HStack {
            if message.isUser {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(message.content)
                        .font(.body)
                        .padding(14)
                        .background(userMessageBackgroundColor)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            } else {
                VStack(alignment: .leading) {
                    Text(message.content)
                        .font(.body)
                        .padding(14)
                        .background(botMessageBackgroundColor)
                        .cornerRadius(15)
                        .foregroundColor(darkTextColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 6)
    }

    private var chatInputBar: some View {
        HStack {
            TextField("Type your message...", text: $userInput)
                .padding(14)
                .background(Color(.systemGray6))
                .cornerRadius(25)
                .padding(.leading, 16)
                .onSubmit {
                    sendMessage()
                }

            Button(action: {
                sendMessage()
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 24))
                    .foregroundColor(darkTextColor)
                    .padding(.trailing, 16)
            }
        }
        .padding(.vertical, 14)
        .background(Color.white)
    }

    private var customTabBar: some View {
        HStack {
            Spacer()
            NavigationLink(destination: MainContentView()) {
                Image(systemName: "house.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
            }
            Spacer()
            NavigationLink(destination: SearchView()) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
            }
            Spacer()
            NavigationLink(destination: ChatbotView()) {
                Image(systemName: "message.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
            }
            Spacer()
            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
            }
            Spacer()
        }
        .padding(.vertical, 12)
        .background(Color.white.shadow(radius: 5))
        .cornerRadius(20)
        .padding(.bottom, 12)
        .padding(.horizontal, 10)
    }

    // MARK: - Helper Methods

    private func sendMessage() {
        if !userInput.isEmpty {
            viewModel.sendMessage(userInput)
            userInput = ""
        }
    }
}

// MARK: - ChatbotView_Previews
struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}
