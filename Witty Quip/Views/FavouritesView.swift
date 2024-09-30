//
//  FavouritesView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-26.
//

import SwiftUI

struct FavouritesView: View {
    @StateObject var quoteViewModel: QuoteViewModel
    var body: some View {
        NavigationStack{
            VStack{
                if quoteViewModel.favoriteQuotes.isEmpty{
                    Image("nonFavImage")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: UIScreen.main.bounds.width/1.5)
                    
                    Text("You don't have any favourite quotes yet.")
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width/1.5)
                        .padding()
                    
                    
                }else{
                    List{
                        ForEach(quoteViewModel.favoriteQuotes){ quote in

                            NavigationLink {
                                SingleQuoteView(quoteModel: quote,quoteViewModel: quoteViewModel)
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
                
            }
            .navigationTitle("Favourites").navigationBarTitleDisplayMode(.inline)
        }.onAppear{
            quoteViewModel.fetchFavoriteQuotes()
        }
    }
}

//#Preview {
//    FavouritesView()
//}
