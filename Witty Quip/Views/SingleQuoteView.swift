//
//  SingleQuoteView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-26.
//

import SwiftUI

struct SingleQuoteView: View {
    
    @Bindable var quoteModel : Quote
    @StateObject var quoteViewModel: QuoteViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                Text(quoteModel.text)
                    .multilineTextAlignment(.center)
                    .font(.custom("HappyMonkey-Regular", size: 40))
                
                
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 150, height: 20)
                    .scaleEffect(x: 9.0, y: 0.5)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            }.padding()
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    quoteViewModel.toggleFavorite(for: quoteModel)
                    quoteViewModel.fetchFavoriteQuotes()
                }, label: {
                    Label("", systemImage: quoteModel.isFavourite == true ? "heart.fill" : "heart")
                            
                })
            }
        }
    }
}

//#Preview {
//    SingleQuoteView()
//}
