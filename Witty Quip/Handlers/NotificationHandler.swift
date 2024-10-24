//
//  NotificationHandler.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-27.
//

import Foundation
import UserNotifications

class NotificationHandler{
    
    func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Authorization granted")
            } else if let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func pushNotification(quoteViewModel: QuoteViewModel, startTime: Date, totalMinutes: Int, repeatingCount: Int) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: startTime)
        let startMinute = calendar.component(.minute, from: startTime)
        
        
        guard totalMinutes > 0, repeatingCount > 0 else {
            print("Invalid time interval or repeating count.")
            return
        }
        
        let interval = totalMinutes / repeatingCount
        
        print("interval: \(interval)")
        
        
        for i in 0..<repeatingCount {
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = AppConstants.appName
            notificationContent.body = quoteViewModel.allQuotes.randomElement()?.text ?? AppConstants.defaultQuote
            notificationContent.badge = .init()
            notificationContent.sound = .default
            
            // Calculate notification time
            let totalNotificationMinutes = startMinute + (i * interval)
            let notificationHour = (startHour + (totalNotificationMinutes / 60)) % 24 
            let notificationMinute = totalNotificationMinutes % 60
            
            var dateComponents = DateComponents()
            dateComponents.hour = notificationHour
            dateComponents.minute = notificationMinute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
            
            notificationCenter.add(notificationRequest) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        quoteViewModel.error = error
                        quoteViewModel.showingErrorAlert = true
                    }
                }
            }
        }
    }
    
    
    func cancelNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        print("All notifications have been canceled.")
    }
}
