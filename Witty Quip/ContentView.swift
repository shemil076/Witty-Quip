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
            MainQuoteView(viewModel: viewModel).tabItem {
                Label("Home", systemImage: "quote.bubble")
            }
            
            FavouritesView(viewModel: viewModel).tabItem {
                Label("Favourites", systemImage: "star.fill")
            }
        }
    }
}

//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}




//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}



//        NavigationView {
//            VStack {
//                if let quote = viewModel.currentQuote {
//                    Text(quote.text)
//                        .font(.largeTitle)
//                        .padding()
//                        .multilineTextAlignment(.center)
//
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            viewModel.toggleFavorite(for: quote)
//                        }) {
//                            Image(systemName: quote.isFavourite ? "heart.fill" : "heart")
//                                .foregroundColor(quote.isFavourite ? .red : .gray)
//                                .font(.title)
//                        }
//                    }
//                } else {
//                    Text("No quotes available.")
//                        .font(.largeTitle)
//                }
//
//                Spacer()
//
//                Button(action: {
//                    viewModel.fetchRandomQuote()
//                }) {
//                    Text("Get New Quote")
//                        .font(.title)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//            }
//            .navigationTitle("Witty Quips")
//            .onAppear {
//                viewModel.populateQuotesFromJSON() // Load quotes initially
//            }
//        }
