//
//  ProfileSettingsView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-27.
//

import SwiftUI

struct ProfileSettingsView: View {
    @StateObject var quoteViewModel: QuoteViewModel
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section (header: Text("Notifications")) {
                    NavigationLink {
                        RemindersSettings(quoteViewModel: quoteViewModel) // Corrected typo
                    } label: {
                        Label("Reminders", systemImage: "bell") // Corrected typo
                    }
                }
                
                Section (header: Text("General")) {
                    Button(action: {
                        sendEmail()
                    }) {
                        Label("WebSite", systemImage: "globe")
                    }
                    Button(action: {
                        sendEmail()
                    }) {
                        Label("Privacy Policy", systemImage: "lock.fill")
                    }
                    Button(action: {
                        sendEmail()
                    }) {
                        Label("Terms of Use", systemImage: "lock.document")
                    }
                    Button(action: {
                        sendEmail()
                    }) {
                        Label("Contact Us", systemImage: "envelope.fill")
                    }
                }
                
            }
            .navigationBarTitle("Profile Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                    .accessibilityLabel("Cancel Profile Settings")
                }
            }
        }
    }
    
    func sendEmail() {
        let email = "mailto:\(AppConstants.contantEmail)"
        if let emailURL = URL(string: email) {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            }
        }
    }
}


//#Preview {
//    ProfileSettingsView()
//}
