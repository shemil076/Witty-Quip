//
//  FavouritesView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-26.
//

import SwiftUI

struct FavouritesView: View {
    @StateObject var viewModel: QuoteViewModel
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    ForEach(viewModel.favoriteQuotes){ quote in

                        NavigationLink {
                            SingleQuoteView(quoteModel: quote,viewModel: viewModel)
                        } label: {
                            HStack{
                                Text(quote.text)
                                    .font(.footnote)
                                    .padding()
                            }
                        }
                        
                    }
                }
            }
            .navigationTitle("Favourites").navigationBarTitleDisplayMode(.inline)
        }.onAppear{
            viewModel.fetchFavoriteQuotes()
        }
    }
}

//#Preview {
//    FavouritesView()
//}
