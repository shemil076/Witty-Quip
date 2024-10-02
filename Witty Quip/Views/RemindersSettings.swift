//
//  RimindersSettings.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-27.
//

import SwiftUI

struct RemindersSettings: View {
    @State var notificationHandler = NotificationHandler()
    @StateObject var quoteViewModel: QuoteViewModel
    @State private var hasRequestedPermission: Bool = false
    
    @State private var startTime: Date = UserDefaults.standard.object(forKey: "startTime") as? Date ?? Date()
    @State private var endTime: Date = UserDefaults.standard.object(forKey: "endTime") as? Date ?? Date().addingTimeInterval(3600)
    @State private var remindersPerDay: Int = UserDefaults.standard.value(forKey: "remindersPerDay") as? Int ?? 1
    
    @State var defualtReminder: Bool = UserDefaults.standard.bool(forKey: "defaultReminder")
    @State var customReminder: Bool = UserDefaults.standard.bool(forKey: "customReminder")
    @State var isInvalidPeriod: Bool = false
    @State var isInvalidRepeatingCount: Bool = false
    
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
                                    ForEach(1..<25, id: \.self) { number in
                                        Text("\(number)")
                                            .foregroundColor(defualtReminder ? .gray : .primary)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(.menu)
                                .disabled(defualtReminder)
                                .onChange(of: remindersPerDay) {
                                    customReminder = false
                                    UserDefaults.standard.set(remindersPerDay, forKey: "remindersPerDay")
                                }
                            }
                            
                            // Validation and Display
                            if (endTime > startTime) {
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
            .navigationTitle("Reminders")
        }.alert("The end time should be at least 10 minutes after the start time.", isPresented: $isInvalidPeriod) {
            Button("OK") {
                customReminder = false
            }
        }
        .alert("Reduce the number of notifications respective to the period", isPresented: $isInvalidRepeatingCount) {
            Button("OK") {
                customReminder = false
            }
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
            let endTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
            let totalMinutes = extractTimeAndValidate(startTime: startTime, endTime: endTime, repeatingCount: 10)
            notificationHandler.pushNotification(quoteViewModel: quoteViewModel, startTime: startTime, totalMinutes: totalMinutes, repeatingCount: 10)
        } else {
            notificationHandler.cancelNotifications()
            print("Default reminder disabled")
        }
        UserDefaults.standard.set(defualtReminder, forKey: "defaultReminder")
    }
    
    private func handleCustomReminderChange() {
        if customReminder {
            print("Custom reminder enabled")
            
            
            let totalMinutes = extractTimeAndValidate(startTime: startTime, endTime: endTime, repeatingCount: remindersPerDay)
            if !isInvalidPeriod{
                notificationHandler.pushNotification(quoteViewModel: quoteViewModel, startTime: startTime, totalMinutes: totalMinutes, repeatingCount: remindersPerDay)
            }
        } else {
            notificationHandler.cancelNotifications()
            print("Custom reminder disabled")
        }
        UserDefaults.standard.set(customReminder, forKey: "customReminder")
    }
    
    private func extractTimeAndValidate(startTime: Date, endTime: Date,repeatingCount: Int) -> Int{
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: startTime)
        let startMinute = calendar.component(.minute, from: startTime)
        let endHour = calendar.component(.hour, from: endTime)
        let endMinute = calendar.component(.minute, from: endTime)
        
        let totalMinutes = (endHour * 60 + endMinute) - (startHour * 60 + startMinute)
        
        print("total mins",totalMinutes)
        print("repeatingCount",repeatingCount)
        
        
        guard totalMinutes >= 10, repeatingCount > 0  else {
            print("Invalid time interval or repeating count.")
            isInvalidPeriod = true
            return 0
        }
        
        let interval = totalMinutes / repeatingCount
        
        guard interval > 0 else {
            isInvalidRepeatingCount = true
            return 0
        }
        isInvalidPeriod = false
        isInvalidRepeatingCount = false
        return totalMinutes
    }
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


//#Preview {
//    RemindersSettings()
//}
