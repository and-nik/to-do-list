//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by And Nik on 14.07.23.
//

import CoreData

final class CoreDataManager: CoreDataManagerProtocol {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    init(name: String) {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores { persistentStore, error in
            if let error { print(error) }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        self.context = container.viewContext
    }
    
    
}

