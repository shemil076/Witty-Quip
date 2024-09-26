//
//  Witty_QuipApp.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-25.
//

//import SwiftUI
//import SwiftData
//
//@main
//struct Witty_QuipApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView(modelContext: ModelContext)
//        }
//        .modelContainer(sharedModelContainer)
//    }
//}

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
