//
//  PrivacyPolicyView.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-10-28.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                Text("Last Updated: October 28, 2024")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Group {
                    Text("Thank you for using Witty Quip. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use the App. By using the App, you agree to the terms described below.")

                    Text("1. Information We Collect")
                        .font(.headline)
                    Text("We do not collect or store any personal information. The App operates without collecting personally identifiable information or any sensitive data from users.")

                    Text("2. How We Use Information")
                        .font(.headline)
                    Text("The App utilizes local data storage, notifications, and sharing features to provide an enhanced user experience. Here’s a breakdown of how data is handled within the App:\n\nQuotes Storage: We pre-load quotes from a JSON file, which are saved locally within the App using SwiftData. These quotes are stored solely within your device and are not shared with any external servers.\n\nNotifications: The App allows you to schedule notifications to receive random quotes within a specified time period. The notification settings, including the scheduled times, are saved in UserDefaults, ensuring your preferences are maintained locally. Notifications are managed through Apple’s UNUserNotificationCenter, and no information about the notifications or your usage patterns is stored or shared.\n\nClipboard Access: When using the \"Copy to Clipboard\" feature, a quote is copied to your clipboard upon request. The App does not access or store any clipboard content.\n\nShareLink Feature: The App includes a \"Share Quote\" option, allowing you to share quotes along with our app signature via the ShareLink feature. When sharing a quote, the text is shared using only the apps or contacts you choose. The App does not store, track, or collect any data related to shared content.")

                    Text("3. Data Retention")
                        .font(.headline)
                    Text("All quotes are stored locally on your device. Since the App does not collect or store any personal data, we retain only the locally stored quotes and notification settings within the App. This data remains on your device and is deleted if you uninstall the App.")

                    Text("4. Third-Party Services")
                        .font(.headline)
                    Text("The App does not utilize any third-party services for data collection, analytics, or advertising.")

                    Text("5. Security")
                        .font(.headline)
                    Text("We take security seriously and strive to protect your data. Since the App does not collect or transmit any personal data, there is minimal risk to your data privacy.")

                    Text("6. Children’s Privacy")
                        .font(.headline)
                    Text("The App is intended for general audiences and does not collect any personal information from children. If you are under the age of 13, please use the App with parental guidance.")

                    Text("7. Changes to This Privacy Policy")
                        .font(.headline)
                    Text("We may update this Privacy Policy to reflect changes in our practices. If changes are made, the \"Last Updated\" date at the top of the policy will be revised. Continued use of the App after changes indicates your acceptance of the updated Privacy Policy.")

                    Text("8. Contact Us")
                        .font(.headline)
                    Text("If you have any questions or concerns about this Privacy Policy, please contact us at \(AppConstants.contactEmail).")
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}



#Preview {
    PrivacyPolicyView()
}
