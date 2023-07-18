//
//  NotificationManager.swift
//  ToDoList
//
//  Created by And Nik on 16.07.23.
//

import Foundation
import UserNotifications

final class NotificationManager: NotificationManagerProtocol {
    
    var timeInterval: Int = 0 //in sec
    
    private var timeString: String {
        if timeInterval/60 < 60 {
            return "minutes"
        } else if timeInterval/24/60/60 == 1 {
            return "day"
        } else {
            return "hour"
        }
    }
    
    private var timeInt: Int {
        if timeInterval/60 < 60 {
            return timeInterval/60
        } else if timeInterval/24/60/60 == 1 {
            return timeInterval/24/60/60
        } else {
            return timeInterval/60/60
        }
    }
    
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isSeccess, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(date: Date, title: String, body: String) {
        let identifier = date.stringDate + " " + date.stringTime + ":" + date.stringSec
        let triggeredDate = date - Double(timeInterval)
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggeredDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = timeInterval == 0 ? "Reminder" : "Reminder: in \(timeInt) \(timeString)"
        content.subtitle = title
        content.body = body
        content.sound = .default
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeNotification(date: Date) {
        let identifier = date.stringDate + " " + date.stringTime + ":" + date.stringSec
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func changeTimeInterval(times: [Date], timeInterval: Int) {
        self.timeInterval = timeInterval
        Task {
            var newRequests = [UNNotificationRequest]()
            let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
            requests.enumerated().forEach { index, request in
                let newTriggeredDate = times[index] - Double(self.timeInterval)
                let newDateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newTriggeredDate)
                let newTrigger = UNCalendarNotificationTrigger(dateMatching: newDateComp, repeats: false)
                let newContent = UNMutableNotificationContent()
                newContent.title = self.timeInterval == 0 ? "Reminder" : "Reminder: in \(timeInt) \(timeString)"
                newContent.subtitle = request.content.subtitle
                newContent.body = request.content.body
                newContent.sound = request.content.sound
                let newRequest = UNNotificationRequest(identifier: request.identifier, content: newContent, trigger: newTrigger)
                newRequests.append(newRequest)
            }
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            newRequests.forEach { request in
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
}
