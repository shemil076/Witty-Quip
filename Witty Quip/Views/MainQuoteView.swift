//
//  MainQuoteView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-26.
//

import SwiftUI
import SwiftData
import UIKit

struct MainQuoteView: View {
    @StateObject var quoteViewModel: QuoteViewModel
    @State private var currentIndex = 0
    @State var showSettingsSheet: Bool = false
    @State private var isCopied: Bool = false
    
    @Environment(\.sizeCategory) var sizeCategory

    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    
                    if quoteViewModel.isLoading{
                        VStack(){
                            ProgressView()
                                .frame(width : geometry.size.width, height: geometry.size.height)
                        }
                    }else{
                        ForEach(0..<quoteViewModel.allQuotes.count, id: \.self) { index in
                            if index < quoteViewModel.allQuotes.count {
                                let quote = quoteViewModel.allQuotes[index]
                                VStack {
                                    Text(quote.text)
                                        .multilineTextAlignment(.center)
                                        .font(.custom("HappyMonkey-Regular", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize))
                                        .minimumScaleFactor(sizeCategory.customMinScaleFactor)
                                        .offset(y: CGFloat(index - self.currentIndex) * geometry.size.height)
                                        .padding(.top, 10)
                                        .accessibilityValue(quote.text)
                                    
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 150, height: 20)
                                        .scaleEffect(x: 9.0, y: 0.5)
                                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                        .offset(y: CGFloat(index - self.currentIndex) * geometry.size.height)
                                    
                                    HStack(spacing: 30) {

                                        ShareLink(item: quote.text + AppConstants.signature){
                                            Image(systemName: "square.and.arrow.up")
                                                .font(.system(size: 20))
                                                .foregroundColor(.blue)
                                                .accessibilityLabel("Share Quote")
                                                .frame(width: 44, height: 44)
                                                .accessibilityHint("Shares the current quote")
                                        }
                                        .offset(y: CGFloat(index - self.currentIndex) * geometry.size.height)
                                        
                                        Button {
                                            Utils.copyQuoteToClipboard(quote: quote, isCopied: $isCopied)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                isCopied = false // Reset the isCopied state
                                            }
                                        } label: {
                                            Image(systemName: isCopied ? "document.on.clipboard.fill" : "doc.on.clipboard")
                                                .font(.system(size: 20))
                                                .foregroundColor(.blue)
                                                .frame(width: 44, height: 44)
                                                .accessibilityLabel("Copy Quote")
                                                .accessibilityHint("Copies the current quote to clipboard")
                                        }
                                        .offset(y: CGFloat(index - self.currentIndex) * geometry.size.height)
                                    }
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                                }
                                .onChange(of : currentIndex){
                                    if currentIndex == quoteViewModel.allQuotes.count - 1 {
                                        fetchQuotesIfNeeded()
                                    }
                                }
                                .padding(20)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                            }
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(
                                            width: max(44, min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 8),
                                                   height: max(44, min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 8)
                                        )
                                    
                                    Button {
                                        showSettingsSheet.toggle()
                                    } label: {
                                        Image(systemName: "person")
                                            .font(.system(size: 30))
                                            .foregroundColor(.blue)
                                            .accessibilityLabel("Settings")
                                            .accessibilityHint("Opens the settings screen")
                                    }
                                }
                                .padding()
                            }
                            .padding(.bottom, UIScreen.main.bounds.height/8)
                        }
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            withAnimation(.spring()) {
                                if value.translation.height < -70 && self.currentIndex < quoteViewModel.allQuotes.count - 1 {
                                    self.currentIndex += 1
                                } else if value.translation.height > 70 && self.currentIndex > 0 {
                                    self.currentIndex -= 1
                                }
                            }
                        }
                )
            }.alert(isPresented: $quoteViewModel.showingErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(quoteViewModel.error?.localizedDescription ?? "Unknown Error"),
                    dismissButton: .default(Text("OK"), action: {
                                quoteViewModel.showingErrorAlert = false
                                quoteViewModel.error = nil
                            })
                )
            }
            .sheet(isPresented: $showSettingsSheet, content: {
                ProfileSettingsView(quoteViewModel: quoteViewModel)
            })
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if let currentQuote = quoteViewModel.allQuotes[safe: currentIndex] {
                        Button(action: {
                            withAnimation{
                                quoteViewModel.toggleFavorite(for: currentQuote)
                            }
                        }, label: {
                            Label("", systemImage: currentQuote.isFavourite ? "heart.fill" : "heart")
                        })
                        .accessibilityLabel(currentQuote.isFavourite ? "Unfavorite Quote" : "Favorite Quote")
                        .accessibilityHint("Toggles favorite status of the current quote")
                    }
                }
            }
        }
        
        .onAppear {
            if quoteViewModel.allQuotes.isEmpty {
//                quoteViewModel.fetchRandomQuote()
                
                quoteViewModel.fetchRandomUniqueQuotes(limit: AppConstants.fetchLimit)
            }
        }
    }
    
    private func fetchQuotesIfNeeded(){
        if !quoteViewModel.isLoading{
            quoteViewModel.fetchRandomUniqueQuotes(limit: AppConstants.fetchLimit)
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}



//
//#Preview {
//    let viewModel = QuoteViewModel()
//    MainQuoteView(viewModel: viewModel)
//}
