//  SearchView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

// SearchView.swift
import SwiftUI

// MARK: - SearchView
struct SearchView: View {
    let darkTextColor = Color.black
    let lightGrayColor = Color.gray.opacity(0.6)
    
    @State private var searchText: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            
            // Title and Subtitle
            Text("Search Games")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(darkTextColor)
                .padding(.horizontal)
                .padding(.top, 70)
            
            Text("Find and join your favorite games")
                .font(.subheadline)
                .foregroundColor(lightGrayColor)
                .padding(.horizontal)
                .padding(.bottom, 20)
            
            // Search Bar
            HStack {
                TextField("Search by name or location", text: $searchText)
                    .padding(.leading, 20)
                    .frame(height: 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 20)
                        }
                    )
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
            
            // Game cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image("dome") // Replace with your image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200) // Adjusted size
                            .cornerRadius(20)
                        
                        Text("Yellow theme Interior")
                            .font(.headline)
                            .foregroundColor(darkTextColor)
                        
                        Text("Central Park")
                            .font(.subheadline)
                            .foregroundColor(lightGrayColor)
                        
                        // Additional Info
                        HStack {
                            Text("Date: 11/02/2024")
                                .font(.caption)
                                .foregroundColor(lightGrayColor)
                            Spacer()
                            Text("8 Players")
                                .font(.caption)
                                .foregroundColor(lightGrayColor)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Image("maidan") // Replace with your image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 180) // Adjusted size
                            .cornerRadius(20)
                        
                        Text("Gray theme Interior")
                            .font(.headline)
                            .foregroundColor(darkTextColor)
                        
                        Text("Riverfront Stadium")
                            .font(.subheadline)
                            .foregroundColor(lightGrayColor)
                        
                        // Additional Info
                        HStack {
                            Text("Date: 12/02/2024")
                                .font(.caption)
                                .foregroundColor(lightGrayColor)
                            Spacer()
                            Text("6 Players")
                                .font(.caption)
                                .foregroundColor(lightGrayColor)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Custom tab bar (this remains the same)
            HStack {
                Spacer()
                Image(systemName: "house.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
                Spacer()
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
                Spacer()
                NavigationLink(destination: ChatbotView()) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 28))
                        .foregroundColor(darkTextColor)
                }
                Spacer()
                Image(systemName: "person.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
                Spacer()
            }
            .background(Color.white.shadow(radius: 5))
            .background(Color.white)
            .cornerRadius(20)
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - SearchView_Previews
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
