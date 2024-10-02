//
//  ContentView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel: QuoteViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: QuoteViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        TabView {
            MainQuoteView(quoteViewModel: viewModel).tabItem {
                Label("Home", systemImage: "quote.bubble")
            }
            
            FavouritesView(quoteViewModel: viewModel).tabItem {
                Label("Favourites", systemImage: "star.fill")
            }
        }
    }
}
