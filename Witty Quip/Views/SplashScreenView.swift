//
//  SplashScreenView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-10-03.
//

import SwiftUI

struct SplashScreenView: View {
    @StateObject var quoteViewModel: QuoteViewModel
    @Binding var isActive: Bool

    @Environment(\.sizeCategory) var sizeCategory
    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height / 8) {
            VStack {
                Text("Witty Quip")
                    .font(.largeTitle).bold()
                    .accessibilityLabel("Witty Quip Name within the splash screen")
                
                Text("Unleash your sarcasm!")
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(sizeCategory.customMinScaleFactor)
                    .font(.custom("HappyMonkey-Regular", size: UIFont.preferredFont(forTextStyle: .title3).pointSize))
                    .accessibilityLabel("Unleash your sarcasm! text within the splash screen")
                    .padding(10)
                    .padding(.horizontal,15)
            }
            
            VStack {
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 25)
                    .rotationEffect(.degrees(10))
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 25)
                    .rotationEffect(.degrees(10))
            }
            .padding(.leading, 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .task {
            quoteViewModel.populateQuotesFromJSON()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    
    }
}

//#Preview {
//    SplashScreenView(isActive: .constant(true))
//}
