//
//  FavoriteView.swift
//  ToDoList
//
//  Created by And Nik on 15.07.23.
//

import SwiftUI

struct FavoriteView: View {
    
    private let tasks: [ToDoTask]
    
    init(tasks: [ToDoTask]) {
        self.tasks = tasks
    }

    var body: some View {
        NavigationView {
            if sortedFavoriteTasks.isEmpty {
                Text("No favorite tasks")
                    .frame(alignment: .center)
            } else {
                List {
                    ForEach(sortedFavoriteTasks, id: \.self) { task in
                        FavoriteTaskView(task: task)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Favorite")
            }
        }
    }
    
    private var sortedFavoriteTasks: [ToDoTask] {
        tasks.filter { $0.isFavorite }.sorted { $0.date < $1.date }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView(tasks: [ToDoTask]())
    }
}
