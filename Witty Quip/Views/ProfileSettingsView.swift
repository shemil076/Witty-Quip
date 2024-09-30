//
//  ProfileSettingsView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-27.
//

import SwiftUI

struct ProfileSettingsView: View {
    @StateObject var quoteViewModel: QuoteViewModel
    @Environment(\.dismiss) var dimiss
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    NavigationLink {
                        RimindersSettings(quoteViewModel: quoteViewModel)
                    } label: {
                        Label("Riminders", systemImage: "bell")
                    }
                    
                    Label("Mode", systemImage: "moon")
                }
            }.navigationBarTitle("Profile Settings").navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dimiss()
                        }, label: {
                            Text("Cancel")
                        })
                    }
                }
        }
    }
}

//#Preview {
//    ProfileSettingsView()
//}
