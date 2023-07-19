//
//  NotificationsView.swift
//  ToDoList
//
//  Created by And Nik on 16.07.23.
//

import SwiftUI
import UserNotifications

struct NotificationsView: View {
    
    var userDefaultManager: UserDefaultManaferProtocol
    var notificationManager: NotificationManagerProtocol
    var coreDataManager: CoreDataManagerProtocol
    
    var settings: Settings
    
    @State private var timeInterval: Int = 0
    
    private let timeIntervals: [(title: String, time: Int)] = [
        (title: "None", time: 0),
        (title: "In 5 minutes", time: 5*60),
        (title: "In 10 minutes", time: 10*60),
        (title: "In 15 minutes", time: 15*60),
        (title: "In 30 minutes", time: 30*60),
        (title: "In 1 hour", time: 1*60*60),
        (title: "In 3 hour", time: 3*60*60),
        (title: "In 5 hour", time: 5*60*60),
        (title: "In 1 day", time: 1*24*60*60),
    ]
    
    var body: some View {
        VStack {
            Form {
                Section {
                    ForEach(timeIntervals, id: \.title) { interval in
                        HStack {
                            Text(interval.title)
                            Spacer()
                            if interval.time == timeInterval {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(uiColor: .tintColor))
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            timeInterval = interval.time
                            let times = coreDataManager.getData().map { $0.date }.filter { $0 > Date() }
                            notificationManager.changeTimeInterval(times: times,timeInterval: interval.time)
                            settings.notificationsTimeInterval = timeInterval
                            userDefaultManager.saveSettings(settings: settings)
                        }
                    }
                } header: {
                    Text("Notification time interval")
                } footer: {
                    Text("You will become a reminder as notification beefore task begin in origin time")
                }
            }
            Text("WARNING!\nIf you have pending notification in less time you set, you will lose all of them and no way to restore")
                .foregroundColor(.red)
                .padding(10)
                .background(Material.regularMaterial)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Notifications")
        .onAppear {
            timeInterval = settings.notificationsTimeInterval
        }
    }
}
