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
    @Published var error: Error?
    @Published var showingErrorAlert: Bool = false
    
    
    private var modelContext: ModelContext
    
//    Lazy Loading implementation
    private var fetchedQuoteIDs: Set<UUID> = []
    private var totalNumberOfQuotes: Int = 0
    
    private let userDefaultsKey = "DisplayedQuoteIDs"
    
    
    var isErrorPresent: Bool {
           return error != nil
       }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
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
            self.error = error
            self.showingErrorAlert = true
        }
    }
    
    
    
    func populateQuotesFromJSON() {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json") else {
            self.error = error
            self.showingErrorAlert = true
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
                self?.error = error
                self?.showingErrorAlert = true
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
                
//                fetchRandomQuote()
                fetchRandomUniqueQuotes(limit: AppConstants.fetchLimit)
            }
        } catch {
            print("Error fetching or inserting quotes: \(error.localizedDescription)")
            self.error = error
            self.showingErrorAlert = true
        }
        
        isLoading = false
    }

    
//    func fetchRandomQuote() {
//        
//        let fetchDescriptor = FetchDescriptor<Quote>()
//        isLoading = true
//        do {
//            
//            if self.allQuotes.isEmpty {
//                
//                let fetchedQuotes = try modelContext.fetch(fetchDescriptor)
//                
//                guard !fetchedQuotes.isEmpty else {
//                    print("No quotes found.")
//                    return
//                }
//                
//                self.allQuotes = fetchedQuotes
//            }
//            
//            self.allQuotes.shuffle()
//            
//            
//        } catch {
//            print("Failed to fetch quotes: \(error)")
//            self.error = error
//            self.showingErrorAlert = true
//        }
//        isLoading = false
//    }
    
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
            self.error = error
            self.showingErrorAlert = true
            print("Failed to fetch quotes: \(error)")
        }
    }
    
    
//    Lazy loading implementation
    
    private func loadDisplayedQuoteIDs(){
        let uuidStrings = fetchedQuoteIDs.map{$0.uuidString}
        UserDefaults.standard.set(uuidStrings, forKey: userDefaultsKey)
    }
    
    
    private func saveDisplayedQuoteIDs(){
        if let uuidStrings = UserDefaults.standard.array(forKey: "DisplayedQuoteIDs") as? [String]{
            fetchedQuoteIDs = Set(uuidStrings.compactMap{UUID(uuidString: $0)})
        }
    }
    
    func fetchRandomUniqueQuotes(limit: Int = 100){
        isLoading = true
        
        let fetchDescriptor = FetchDescriptor<Quote>()
        
        do {
            totalNumberOfQuotes = try modelContext.fetchCount(fetchDescriptor)
            let availableQuotesCount = totalNumberOfQuotes - fetchedQuoteIDs.count
            let fetchLimit = min(limit, availableQuotesCount)
            
            if fetchedQuoteIDs.count >= totalNumberOfQuotes{
                fetchedQuoteIDs.removeAll()
                print("All the quotes have been fetched... RESETTING...")
            }
            
            
            var randomOffsets : Set<Int> = []
            
            while randomOffsets.count < fetchLimit{
                randomOffsets.insert(Int.random(in: 0..<totalNumberOfQuotes))
            }
            
            for offset in randomOffsets {
                var fetchDescriptor = FetchDescriptor<Quote>()
                fetchDescriptor.fetchLimit = 1
                fetchDescriptor.fetchOffset = offset
                
                let fetchedQuotes = try modelContext.fetch(fetchDescriptor)
                
                guard let quote = fetchedQuotes.first else {
                    continue
                }
                
                if !fetchedQuoteIDs.contains(quote.id){
                    fetchedQuoteIDs.insert(quote.id)
                    allQuotes.append(quote)
                }
            }
            
            saveDisplayedQuoteIDs()
        }catch{
            print("Failed to fetch quotes: \(error.localizedDescription)")
            self.error = error
            self.showingErrorAlert = true
        }
        isLoading = false
    }
}


//#Preview {
//    QuoteViewModel(modelContext: <#ModelContext#>)
//}
