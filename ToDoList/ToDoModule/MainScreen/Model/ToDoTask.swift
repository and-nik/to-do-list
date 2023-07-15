//
//  ToDoTask.swift
//  ToDoList
//
//  Created by And Nik on 12.07.23.
//

import Foundation
import CoreData

struct ToDoTask: Codable, Hashable {
    
    var title: String
    var description: String
    var date: Date
    var status: Bool = false
    var tag: Tag
    var isFavorite: Bool = false
    
    init(title: String, description: String, date: Date, status: Bool = false, tag: Tag = .normal, isFavorite: Bool = false) {
        self.title = title
        self.description = description
        self.date = date
        self.status = status
        self.tag = tag
        self.isFavorite = isFavorite
    }
}
