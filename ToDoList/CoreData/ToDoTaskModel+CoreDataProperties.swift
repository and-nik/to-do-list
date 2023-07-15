//
//  ToDoTaskModel+CoreDataProperties.swift
//  ToDoList
//
//  Created by And Nik on 14.07.23.
//
//

import Foundation
import CoreData


extension ToDoTaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoTaskModel> {
        return NSFetchRequest<ToDoTaskModel>(entityName: "ToDoTaskModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var tag: Int16
    @NSManaged public var isFavorite: Bool
    @NSManaged public var date: Date?
    @NSManaged public var status: Bool

}

extension ToDoTaskModel : Identifiable {

}
