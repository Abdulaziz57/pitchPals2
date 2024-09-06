//
//  ChatbotView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 28/08/2024.
//
import SwiftUI
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    
    let openAI = OpenAI(apiToken: "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")
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: self.messages.map({
                .init(role: .user, content: $0.content)!
            }),
            model: .gpt3_5Turbo
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                guard let message = choice.message.content?.string else { return }
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message, isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}


struct ChatbotView: View {
    @StateObject var chatController = ChatController()
    @State private var userInput: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            chatTitleBar
            chatMessagesScrollView
            Divider()
            chatInputBar
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
                .foregroundColor(.black)
                .padding(.vertical, 12)
            Spacer()
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var chatMessagesScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(chatController.messages) { message in
                    chatBubble(for: message)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
        .background(Color.white)
    }
    
    private func chatBubble(for message: Message) -> some View {
        HStack {
            if message.isUser {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(message.content)
                        .font(.body)
                        .padding(14)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            } else {
                VStack(alignment: .leading) {
                    Text(message.content)
                        .font(.body)
                        .padding(14)
                        .background(Color(.systemGray5))
                        .cornerRadius(15)
                        .foregroundColor(.black)
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
            
            Button(action: {
                sendMessage()
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
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
                    .foregroundColor(.black)
            }
            Spacer()
            NavigationLink(destination: SearchView()) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 28))
                    .foregroundColor(.black)
            }
            Spacer()
            NavigationLink(destination: ChatbotView()) {
                Image(systemName: "message.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.black)
            }
            Spacer()
            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(.vertical, 12)
        .background(Color.white.shadow(radius: 5))
        .cornerRadius(20)
        .padding(.bottom, 25)
        .padding(.horizontal, 10)
        .navigationBarBackButtonHidden(true) // Hide the back button

    }
    
    // MARK: - Helper Methods
    
    private func sendMessage() {
        if !userInput.isEmpty {
            chatController.sendNewMessage(content: userInput)
            userInput = ""
        }
    }
}

// MARK: - Preview
struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}
