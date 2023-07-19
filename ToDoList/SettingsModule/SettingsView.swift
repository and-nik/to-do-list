//
//  SettingsView.swift
//  ToDoList
//
//  Created by And Nik on 16.07.23.
//

import SwiftUI

struct SettingsView: View {
    
    var notificationManager: NotificationManagerProtocol
    var userDefaultManager: UserDefaultManaferProtocol
    var coreDataManager: CoreDataManagerProtocol
    
    var settings: Settings
    
    @State private var isUserSingIn: Bool = false
    
    init(userDefaultManager: UserDefaultManaferProtocol, notificationManager: NotificationManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.userDefaultManager = userDefaultManager
        self.notificationManager = notificationManager
        self.coreDataManager = coreDataManager
        self.settings = userDefaultManager.getSettings()
    }
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    NotificationsView(userDefaultManager: userDefaultManager,
                                      notificationManager: notificationManager,
                                      coreDataManager: coreDataManager,
                                      settings: settings)
                } label: {
                    HStack {
                        Image(systemName: "bell.badge.fill")
                            .foregroundColor(.white)
                            .padding(5)
                            .background {
                                Rectangle()
                                    .fill(.blue)
                                    .cornerRadius(5)
                            }
                        Text("Notifications")
                    }
                }
                
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
