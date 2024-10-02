//
//  Utils.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-10-01.
//

import Foundation
import UIKit
import SwiftUI

struct Utils{
    static func copyQuoteToClipboard(quote: Quote, isCopied: Binding<Bool>) {
        UIPasteboard.general.string = quote.text + AppConstants.signature
        isCopied.wrappedValue = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isCopied.wrappedValue = false
        }
    }
    
    static func shareQuote(quote: String) {
        let fullQuote = quote + AppConstants.signature
        let activityVC = UIActivityViewController(activityItems: [fullQuote], applicationActivities: nil)
        
        DispatchQueue.main.async {
            if let currentWindow = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                .first {
                currentWindow.rootViewController?.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}
