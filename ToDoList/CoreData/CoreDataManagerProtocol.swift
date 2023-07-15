//
//  CoreDataManagerProtocol.swift
//  ToDoList
//
//  Created by And Nik on 14.07.23.
//

import CoreData

protocol CoreDataManagerProtocol {
    var context: NSManagedObjectContext { get set }
}

extension CoreDataManagerProtocol {
    
    func saveContex() {
        if context.hasChanges {
            do { try context.save() }
            catch { print(error) }
        }
    }
    
    func getData() -> [ToDoTask] {
        do {
            let tasksModel = try context.fetch(ToDoTaskModel.fetchRequest())
            return tasksModel.map { model in
                let task = ToDoTask(title: model.title ?? "",
                                    description: model.desc ?? "",
                                    date: model.date ?? Date(),
                                    status: model.status,
                                    tag: Tag(rawValue: Int(model.tag)) ?? .normal,
                                    isFavorite: model.isFavorite)
                return task
            }
        } catch {
            print(error)
            return []
        }
    }
    
    func saveData(task: ToDoTask) {
        
        let taskModel = ToDoTaskModel(context: context)
        taskModel.title = task.title
        taskModel.desc = task.description
        taskModel.date = task.date
        taskModel.status = task.status
        taskModel.tag = Int16(task.tag.rawValue)
        taskModel.isFavorite = task.isFavorite
        saveContex()
    }
    
    func update(task: ToDoTask) {
        do {
            let tasksModel = try context.fetch(ToDoTaskModel.fetchRequest())
            tasksModel.forEach { taskModel in
                if taskModel.date == task.date {
                    taskModel.title = task.title
                    taskModel.desc = task.description
                    taskModel.status = task.status
                    taskModel.tag = Int16(task.tag.rawValue)
                    taskModel.isFavorite = task.isFavorite
                    saveContex()
                }
            }
        } catch {
            print(error)
        }
    }
    
    func delete(task: ToDoTask) {
        do {
            let tasksModel = try context.fetch(ToDoTaskModel.fetchRequest())
            tasksModel.forEach { taskModel in
                if taskModel.date == task.date {
                    context.delete(taskModel)
                    saveContex()
                }
            }
        } catch {
            print(error)
        }
    }
}
