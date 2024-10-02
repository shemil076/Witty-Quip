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
    
    
//    func populateQuotesFromJSON() {
//        if let url = Bundle.main.url(forResource: "quotes", withExtension: "json") {
//            isLoading = true
//            do {
//                let data = try Data(contentsOf: url)
//                let decodedQuotes = try JSONDecoder().decode([QuoteData].self, from: data)
//                
//                let fetchDescriptor = FetchDescriptor<Quote>()
//                let existingQuotes = try modelContext.fetchCount(fetchDescriptor)
//                
//                if existingQuotes == 0 {
//                    for quoteData in decodedQuotes{
//                        let newQuote = Quote(text: quoteData.text, isFavourite: quoteData.isFavourite)
//                        modelContext.insert(newQuote)
//                    }
//                    
//                    saveChanges()
//                }
//            }catch {
//                print("Error loading JSON: \(error.localizedDescription)")
//            }
//        }
//        else{
//            print("quotes.json file not found")
//        }
//        isLoading = false
//    }
    
    func populateQuotesFromJSON() {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json") else {
            print("quotes.json file not found")
            return
        }
        
        isLoading = true
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                let decodedQuotes = try JSONDecoder().decode([QuoteData].self, from: data)
                
                DispatchQueue.main.async {
                    self?.insertQuotesInBatches(decodedQuotes)
                }
            } catch {
                print("Error loading JSON: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
    }
    
    func insertQuotesInBatches(_ decodedQuotes: [QuoteData]) {
        let fetchDescriptor = FetchDescriptor<Quote>()
        
        do {
            let existingQuotesCount = try modelContext.fetchCount(fetchDescriptor)
            
            if existingQuotesCount == 0 {
                let batchSize = 1000
                for batchStart in stride(from: 0, to: decodedQuotes.count, by: batchSize) {
                    let batch = decodedQuotes[batchStart..<min(batchStart + batchSize, decodedQuotes.count)]
                    
                    for quoteData in batch {
                        let newQuote = Quote(text: quoteData.text, isFavourite: quoteData.isFavourite)
                        modelContext.insert(newQuote)
                    }
                    
                    saveChanges()
                }
                
                fetchRandomQuote()
            }
        } catch {
            print("Error fetching or inserting quotes: \(error.localizedDescription)")
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
