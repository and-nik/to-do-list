//
//  UserDefaultManaferProtocol.swift
//  ToDoList
//
//  Created by And Nik on 17.07.23.
//

import Foundation

protocol UserDefaultManaferProtocol {
    
    func getSettings() -> Settings
    func saveSettings(settings: Settings)
}
