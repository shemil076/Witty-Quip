//
//  SingleQuoteView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-26.
//

import SwiftUI

struct SingleQuoteView: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    
    @Bindable var quoteModel : Quote
    @StateObject var quoteViewModel: QuoteViewModel
    @State private var isCopied: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                Text(quoteModel.text)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(sizeCategory.customMinScaleFactor)
                    .font(.custom("HappyMonkey-Regular", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize))
                    .accessibilityValue(quoteModel.text)
                
                
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 150, height: 20)
                    .scaleEffect(x: 9.0, y: 0.5)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                HStack(spacing: 30) {
                    ShareLink(item: quoteModel.text + AppConstants.signature){
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 44)
                            .accessibilityLabel("Share Quote")
                            .accessibilityHint("Shares the current quote")
                    }
                    
                    Button {
                        Utils.copyQuoteToClipboard(quote: quoteModel, isCopied: $isCopied)
                    } label: {
                        Image(systemName: isCopied ? "document.on.clipboard.fill" : "doc.on.clipboard")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 44)
                            .accessibilityLabel("Copy Quote")
                            .accessibilityHint("Copies the current quote to clipboard")
                    }
                }
                .padding(.top, 20)
            }.padding()
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    withAnimation { 
                        quoteViewModel.toggleFavorite(for: quoteModel)
                        quoteViewModel.fetchFavoriteQuotes()
                    }
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
