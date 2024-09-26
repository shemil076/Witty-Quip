//
//  SingleQuoteView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-26.
//

import SwiftUI
import SwiftData

struct MainQuoteView: View {
    @StateObject var viewModel: QuoteViewModel
    

    var body: some View {
        NavigationStack {
            Spacer()
            VStack {
                if let quote = viewModel.currentQuote {
                    Text(quote.text)
                        .multilineTextAlignment(.center)
                        .font(.custom("HappyMonkey-Regular", size: 40))
                    
                    
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 150, height: 20)
                        .scaleEffect(x: 9.0, y: 0.5)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
            }.padding()
            
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    viewModel.fetchRandomQuote()
                }, label: {
                    Label("", systemImage: "arrowshape.turn.up.forward")
                })
            }
            
            .padding()
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.toggleFavorite(for: viewModel.currentQuote!)
                    }, label: {
                        Label("", systemImage: viewModel.currentQuote?.isFavourite == true ? "heart.fill" : "heart")
                                
                    })
                }
            }
        }
    }
}
//
//#Preview {
//    let viewModel = QuoteViewModel()
//    MainQuoteView(viewModel: viewModel)
//}
