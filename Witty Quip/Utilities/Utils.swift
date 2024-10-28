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
    
    static func openWebsites(url: String) {
        if let url = URL(string: url) {
                    UIApplication.shared.open(url)
                }
    }
}

extension ContentSizeCategory{
    var customMinScaleFactor: CGFloat{
        switch self {
        case .extraSmall, .small, .medium: return 1
        default : return 0.1
        }
    }
}
