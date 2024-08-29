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
    
    var body: some View {
        VStack {
            // Game cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image("dome") // Replace with your image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 180) // Adjusted size
                            .cornerRadius(20)
                        
                        Text("Yellow theme Interior")
                            .font(.headline)
                            .foregroundColor(darkTextColor)
                        
                        Text("Central Park")
                            .font(.subheadline)
                            .foregroundColor(lightGrayColor)
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
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)

            
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
                Image(systemName: "bell.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkTextColor)
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
