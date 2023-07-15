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
            ToDoView(viewModel: ToDoViewModel(coreDataManager: CoreDataManager(name: "Model")))
        }
    }
}
