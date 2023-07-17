//
//  NotificationManagerProtocol.swift
//  ToDoList
//
//  Created by And Nik on 16.07.23.
//

import Foundation

protocol NotificationManagerProtocol {
    var timeInterval: Int { get set }
    func askPermission()
    func sendNotification(date: Date, title: String, body: String)
    func removeNotification(date: Date)
    func changeTimeInterval(timeInterval: Int)
}
