//  SearchView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

// SearchView.swift

import SwiftUI




// MARK: - SearchView
struct SearchView: View {
    
    @State private var searchText = ""
    @State private var games: [Game] = Game.sampleData

    var body: some View {
        VStack {
            // Search and action buttons with a neumorphic style
            NeumorphicSearchBar(text: $searchText)
                .padding()
            
            // Game list with interactive elements
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(games, id: \.id) { game in
                        GameCardView(game: game)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top)

            Spacer()

        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
}

// MARK: - NeumorphicSearchBar
struct NeumorphicSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: $text)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .softOuterShadow() // Apply soft outer shadow
        )
    }
}


struct GameCardView: View {
    let game: Game // Make sure your Game struct includes an 'organizerProfileImage' property

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {

                VStack(alignment: .leading, spacing: 4) {
                    Text(game.name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                    Text(game.time)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.black)

                    HStack{
                        Image(game.organizerProfileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        
                        Text("7 a side by \(game.organizer)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()

            }
            

            
            HStack {
                ForEach(game.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .foregroundColor(.gray)
                        .clipShape(Capsule())
                }
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(game.price)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 15)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .softInnerShadow(RoundedRectangle(cornerRadius: 20)) // Apply soft inner shadow
        )
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

// MARK: - Soft UI Shadow Modifier
extension View {
    func softOuterShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.15), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(1), radius: 10, x: -5, y: -5)
    }
    
    func softInnerShadow<S: Shape>(_ shape: S) -> some View {
        self
            .overlay(
                shape
                    .stroke(Color.white, lineWidth: 4)
                    .blur(radius: 4)
                    .offset(x: 2, y: 2)
                    .mask(
                        shape
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    )

            )
            .overlay(
                shape
                    .stroke(Color.white, lineWidth: 8)
                    .blur(radius: 4)
                    .offset(x: -2, y: -2)
                    .mask(
                        shape
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    )

            )
    }
}

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                // Your content view goes here

                // Custom Tab Bar
                AnimatedCustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

// MARK: - AnimatedCustomTabBar
struct AnimatedCustomTabBar: View {
    @Binding var selectedTab: Int
    let icons = ["house", "magnifyingglass", "plus.circle", "bell", "person"]
    
    var body: some View {
        VStack {
            Spacer() // This pushes the tab bar to the bottom

            Divider()
            HStack {
                ForEach(0..<icons.count, id: \.self) { index in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            self.selectedTab = index
                        }
                    }) {
                        Image(systemName: icons[index])
                            .foregroundColor(selectedTab == index ? .black : .gray)
                            .imageScale(selectedTab == index ? .large : .medium)
                            .padding(20)
                            .background(selectedTab == index ? Color.black.opacity(0.2) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: selectedTab == index ? 1 : 0)
                            )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .background(
                VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
    }
}



// MARK: - VisualEffectView
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}


// MARK: - SearchView_Previews
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
