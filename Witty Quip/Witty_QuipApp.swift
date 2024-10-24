//
//  Witty_QuipApp.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-25.
//


import SwiftUI
import SwiftData

@main
struct MyApp: App {
    let container = try? ModelContainer(for : Quote.self)
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container!.mainContext)
          
        }
    }
}
