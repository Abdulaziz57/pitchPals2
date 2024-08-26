//
//  PitchPalsApp.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 21/01/2024.
//
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth



@main
struct PitchPalsApp: App {
    
    
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
