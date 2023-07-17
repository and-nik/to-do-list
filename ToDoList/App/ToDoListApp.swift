//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by And Nik on 12.07.23.
//

import SwiftUI

@main
struct ToDoListApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = ToDoViewModel(coreDataManager: CoreDataManager(name: "Model"),
                                          notificationManager: NotificationManager(),
                                          userDefaultManager: UserDefaultManafer())
            ToDoView(viewModel: viewModel)
        }
    }
}
