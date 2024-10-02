//
//  FavouritesView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-26.
//

import SwiftUI

import SwiftUI

struct FavouritesView: View {
    @StateObject var quoteViewModel: QuoteViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if quoteViewModel.favoriteQuotes.isEmpty {
                    Image("nonFavImage")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    Text("You don't have any favourite quotes yet.")
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    List {
                        ForEach(quoteViewModel.favoriteQuotes) { quote in
                            NavigationLink {
                                SingleQuoteView(quoteModel: quote, quoteViewModel: quoteViewModel)
                            } label: {
                                Text(quote.text)
                                    .font(.footnote)
                                    .padding()
                                    .accessibilityIdentifier("favoriteQuote_\(quote.id)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            quoteViewModel.fetchFavoriteQuotes()
        }
    }
}


//#Preview {
//    FavouritesView()
//}
