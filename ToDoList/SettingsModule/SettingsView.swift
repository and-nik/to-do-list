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
    
    var settings: Settings
    
    @State private var isUserSingIn: Bool = false
    
    init(userDefaultManager: UserDefaultManaferProtocol, notificationManager: NotificationManagerProtocol) {
        self.userDefaultManager = userDefaultManager
        self.notificationManager = notificationManager
        self.settings = userDefaultManager.getSettings()
    }
    
    var body: some View {
        NavigationView {
            Form {
//                if !isUserSingIn {
//                    Section {
//                        Button {
//                            print("fff")
//                        } label: {
//                            HStack {
//                                Spacer()
//                                Text("Sign In")
//                                    .foregroundColor(.white)
//                                    .font(.body.bold())
//                                Spacer()
//                            }
//                            .contentShape(Rectangle())
//                        }
//                    }
//                    .listRowBackground(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
//                }
                NavigationLink {
                    NotificationsView(userDefaultManager: userDefaultManager,
                                     notificationManager: notificationManager,
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

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(coreDataManager: CoreDataManager(name: "Model"), notificationManager: NotificationManager())
//    }
//}
