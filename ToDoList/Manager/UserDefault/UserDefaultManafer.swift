//
//  UserDefaultManafer.swift
//  ToDoList
//
//  Created by And Nik on 17.07.23.
//

import Foundation

final class UserDefaultManafer: UserDefaultManaferProtocol {
    
    private enum Keys: String {
        case settings = "settings"
    }
    
    private let standart = UserDefaults.standard
    
    func saveSettings(settings: Settings) {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        standart.set(data, forKey: Keys.settings.rawValue)
    }
    
    
    func getSettings() -> Settings {
        guard let data = standart.object(forKey: Keys.settings.rawValue) as? Data,
              let settings = try? JSONDecoder().decode(Settings.self, from: data) else { return Settings() }
        return settings
    }
    
    
}
