//
//  MainQuoteView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-26.
//

import SwiftUI
import SwiftData

struct MainQuoteView: View {
    @StateObject var quoteViewModel: QuoteViewModel
    @State private var currentIndex = 0
    @State var showSettingsSheet : Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                        ForEach(0..<quoteViewModel.allQuotes.count, id: \.self) { index in
                            if index < quoteViewModel.allQuotes.count {
                                let quote = quoteViewModel.allQuotes[index]
                                VStack {
                                    Text(quote.text)
                                        .multilineTextAlignment(.center)
                                        .font(.custom("HappyMonkey-Regular", size: 40))
                                        .offset(y: CGFloat(index - self.currentIndex) * geometry.size.height)
                                        .animation(.spring(), value: currentIndex)

                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 150, height: 20)
                                        .scaleEffect(x: 9.0, y: 0.5)
                                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                        .offset(y: CGFloat(index - self.currentIndex) * geometry.size.height)
                                        .animation(.spring(), value: currentIndex)
                                    
                                }
                                .padding()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                
                                
                                
                            }
                        }
                        
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray.opacity(0.2)) // Background for the button
                                    .frame(
                                        width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 8,
                                        height: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 8
                                    ) // Size is fixed based on the smaller dimension to avoid resizing issues on rotation.

                                Button {
                                    showSettingsSheet.toggle()
                                } label: {
                                    Image(systemName: "person")
                                        .font(.system(size: 30)) // Increase icon size
                                        .foregroundColor(.blue)  // Color of the icon
                                }
                            }
                            .padding()
                        }
                        .padding(.bottom, 30)
                    }




                        
                    
                    
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.height < -50 && self.currentIndex < quoteViewModel.allQuotes.count - 1 {
                                self.currentIndex += 1
                            } else if value.translation.height > 50 && self.currentIndex > 0 {
                                self.currentIndex -= 1
                            }
                        }
                )
                
            }
//            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $showSettingsSheet, content: {
                ProfileSettingsView(quoteViewModel: quoteViewModel)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if let currentQuote = quoteViewModel.allQuotes[safe: currentIndex] {
                        Button(action: {
                            quoteViewModel.toggleFavorite(for: currentQuote)
                        }, label: {
                            Label("", systemImage: currentQuote.isFavourite ? "heart.fill" : "heart")
                        })
                    }
                }
            }
        }
        .onAppear {
            if quoteViewModel.allQuotes.isEmpty {
                quoteViewModel.fetchRandomQuote() // Ensure you have a method to load allQuotes
            }
        }
    }
}

// Helper extension to safely access array elements
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
