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
                Section {
                    NavigationLink {
                        RemindersSettings(quoteViewModel: quoteViewModel) // Corrected typo
                    } label: {
                        Label("Reminders", systemImage: "bell") // Corrected typo
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
                    .accessibilityLabel("Cancel Profile Settings") // Adding accessibility label for clarity
                }
            }
        }
    }
}


//#Preview {
//    ProfileSettingsView()
//}
