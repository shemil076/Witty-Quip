//
//  RimindersSettings.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-27.
//

import SwiftUI

struct RimindersSettings: View {
    @State var notificationHandler = NotificationHandler()
    @StateObject var quoteViewModel: QuoteViewModel
    @State private var hasRequestedPermission: Bool = false
    
    @State private var startTime: Date = UserDefaults.standard.object(forKey: "startTime") as? Date ?? Date()
    @State private var endTime: Date = UserDefaults.standard.object(forKey: "endTime") as? Date ?? Date().addingTimeInterval(3600)
    @State private var remindersPerDay: Int = UserDefaults.standard.integer(forKey: "remindersPerDay")
    
    @State var defualtReminder: Bool = UserDefaults.standard.bool(forKey: "defaultReminder")
    @State var customReminder: Bool = UserDefaults.standard.bool(forKey: "customReminder")
    
    var body: some View {
        NavigationStack {
            Text("Don’t miss out—set up your daily dose of sarcasm")
                .multilineTextAlignment(.leading)
                .font(.custom("inter", size: 20))
                .padding(.top, 20)
                .padding(.leading, 0)
            ScrollView {
                VStack {
                    GroupBox {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("General Reminder")
                                    .font(.title3).bold()
                                    .foregroundColor(customReminder ? .gray : .primary)
                                    .padding(0)
                                
                                Spacer()
                                Toggle("", isOn: $defualtReminder)
                                    .disabled(customReminder)
                                    .foregroundColor(customReminder ? .gray : .primary)
                                    .onChange(of: defualtReminder) {
                                        handleDefaultReminderChange()
                                    }
                            }
                            Text("9.00am - 10.00pm")
                                .font(.headline)
                                .foregroundColor(customReminder ? .gray : .primary)
                            
                            Text("10x per day")
                                .foregroundColor(customReminder ? .gray : .primary)
                        }
                    }
                    .opacity(customReminder ? 0.5 : 1.0)
                    .animation(.easeInOut, value: customReminder)

                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Custom Reminder")
                                    .font(.title3).bold()
                                    .padding(0)
                                
                                Spacer()
                                Toggle("", isOn: $customReminder)
                                    .disabled(defualtReminder)
                                    .foregroundColor(defualtReminder ? .gray : .primary)
                                    .onChange(of: customReminder) {
                                        handleCustomReminderChange()
                                    }
                            }
                            
                            // Start Time Picker
                            HStack {
                                Text("Start Time")
                                    .font(.headline)
                                    .foregroundColor(defualtReminder ? .gray : .primary)
                                Spacer()
                                DatePicker(
                                    "",
                                    selection: $startTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                                .datePickerStyle(CompactDatePickerStyle())
                                .disabled(defualtReminder)
                                .onChange(of: startTime) {
                                    customReminder = false
                                    UserDefaults.standard.set(startTime, forKey: "startTime")
                                }
                            }
                            
                            // End Time Picker
                            HStack {
                                Text("End Time")
                                    .font(.headline)
                                    .foregroundColor(defualtReminder ? .gray : .primary)
                                Spacer()
                                DatePicker(
                                    "",
                                    selection: $endTime,
                                    in: startTime...,
                                    displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                                .datePickerStyle(CompactDatePickerStyle())
                                .disabled(defualtReminder)
                                .onChange(of: endTime) {
                                    customReminder = false
                                    UserDefaults.standard.set(endTime, forKey: "endTime")
                                }
                            }
                            
                            // Reminders per Day Picker
                            HStack {
                                Text("Reminders per Day")
                                    .font(.headline)
                                    .foregroundColor(defualtReminder ? .gray : .primary)
                                Spacer()
                                Picker("", selection: $remindersPerDay) {
                                    ForEach(1..<25) { number in
                                        Text("\(number)")
                                            .foregroundColor(defualtReminder ? .gray : .primary)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(.menu)
                                .disabled(defualtReminder)
                                .onChange(of: remindersPerDay) {
                                    UserDefaults.standard.set(remindersPerDay, forKey: "remindersPerDay")
                                }
                            }
                            
                            // Validation and Display
                            if endTime > startTime {
                                Text("Selected Time Period: \(formattedTime(from: startTime)) - \(formattedTime(from: endTime))")
                                    .font(.subheadline)
                                    .foregroundColor(defualtReminder ? .gray : .primary)
                            } else {
                                Text("End time should be after start time")
                                    .foregroundColor(defualtReminder ? .gray : .red)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .opacity(defualtReminder ? 0.5 : 1.0)
                    .animation(.easeInOut, value: defualtReminder)
                    
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Riminders")
        }
        .onAppear {
            if !hasRequestedPermission {
                notificationHandler.requestAuthorization()
                hasRequestedPermission = true
            }
        }
    }
    
    private func handleDefaultReminderChange() {
        if defualtReminder {
            print("Default reminder enabled")
            let startTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
            let endTime = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
            notificationHandler.pushNotification(quoteViewModel: quoteViewModel, startTime: startTime, endTime: endTime, repeatingCount: 60)
        } else {
            notificationHandler.cancelNotifications()
            print("Default reminder disabled")
        }
        UserDefaults.standard.set(defualtReminder, forKey: "defaultReminder")
    }

    private func handleCustomReminderChange() {
        if customReminder {
            print("Custom reminder enabled")
            notificationHandler.pushNotification(quoteViewModel: quoteViewModel, startTime: startTime, endTime: endTime, repeatingCount: remindersPerDay)
        } else {
            notificationHandler.cancelNotifications()
            print("Custom reminder disabled")
        }
        UserDefaults.standard.set(customReminder, forKey: "customReminder")
    }

    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


//#Preview {
//    RimindersSettings()
//}
