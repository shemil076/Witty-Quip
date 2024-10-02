//
//  QuoteViewModel.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-25.
//

import SwiftUI
import SwiftData

class QuoteViewModel: ObservableObject {
    
    @Published var favoriteQuotes: [Quote] = []
    @Published var allQuotes: [Quote] = []
    @Published var isLoading: Bool = false
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        populateQuotesFromJSON()
        fetchRandomQuote()
    }
    
    func toggleFavorite(for quote: Quote) {
        quote.isFavourite.toggle()
        quote.updatedDate = Date()
        saveChanges()
    }
    
    private func saveChanges(){
        do {
            try modelContext.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
    
    func populateQuotesFromJSON() {
        if let url = Bundle.main.url(forResource: "quotes", withExtension: "json") {
            isLoading = true
            do {
                let data = try Data(contentsOf: url)
                let decodedQuotes = try JSONDecoder().decode([QuoteData].self, from: data)
                
                let fetchDescriptor = FetchDescriptor<Quote>()
                let existingQuotes = try modelContext.fetchCount(fetchDescriptor)
                
                if existingQuotes == 0 {
                    for quoteData in decodedQuotes{
                        let newQuote = Quote(text: quoteData.text, isFavourite: quoteData.isFavourite)
                        modelContext.insert(newQuote)
                    }
                    
                    saveChanges()
                }
            }catch {
                print("Error loading JSON: \(error.localizedDescription)")
            }
        }
        else{
            print("quotes.json file not found")
        }
        isLoading = false
    }
    
    func fetchRandomQuote() {
        
        let fetchDescriptor = FetchDescriptor<Quote>()
        do {
            
            if self.allQuotes.isEmpty {
                
                let fetchedQuotes = try modelContext.fetch(fetchDescriptor)
                
                guard !fetchedQuotes.isEmpty else {
                    print("No quotes found.")
                    return
                }
                
                self.allQuotes = fetchedQuotes
            }
            
            self.allQuotes.shuffle()
            
            
        } catch {
            print("Failed to fetch quotes: \(error)")
        }
    }
    
    func fetchFavoriteQuotes(){
        
        let fetchDescriptor = FetchDescriptor<Quote>(
            predicate: #Predicate { $0.isFavourite == true },
            sortBy: [
                .init(\.updatedDate)
            ]
        )
        
        do{
            let fetechedQuotes = try modelContext.fetch(fetchDescriptor)
            self.favoriteQuotes = fetechedQuotes.reversed()
            
        }catch {
            print("Failed to fetch quotes: \(error)")
        }
    }
    
    
    
    
}


//#Preview {
//    QuoteViewModel(modelContext: <#ModelContext#>)
//}
