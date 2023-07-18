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
    
    //@State private var isNotificationTimeIntervalAllows: Bool = false
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
        Form {
//            Section {
//                Toggle("Notifications time interval", isOn: $isNotificationTimeIntervalAllows)
//                    .onChange(of: isNotificationTimeIntervalAllows) { newValue in
//                        if !newValue {
//                            notificationManager.changeTimeInterval(timeInterval: 0)
//                        }
//                    }
//            } footer: {
//                Text("Allows application to send notification in some time before task begin")
//            }
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
                Text("You will become a reminder as notification beefore task begin in this time")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Notifications")
        .onAppear {
            timeInterval = settings.notificationsTimeInterval
        }
    }
}
//
//struct NotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationView(coreDataManager: CoreDataManager(name: ""), notificationManager: NotificationManager())
//    }
//}
