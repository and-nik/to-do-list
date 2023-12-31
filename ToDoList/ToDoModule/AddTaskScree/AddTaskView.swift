//
//  AddTaskView.swift
//  ToDoList
//
//  Created by And Nik on 13.07.23.
//

import SwiftUI

struct AddTaskView<ViewModel>: View
where ViewModel: ToDoViewModelProtocol{
    
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var tag: Tag = .normal
    
    @State private var isDateFailureEntered: Bool = false
    
    @FocusState private var focus: Bool//Нужно чтобы title text field получил first responder, но почему-то не работает на айфоне(в симуляторе все работает)
    @Environment(\.dismiss) var dismiss
    
    private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    titleView
                    descriptionView
                }
                Section {
                    dateView
                }
                Section {
                    tagView
                }
            }
            .navigationBarTitle("Add new task", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    doneButton
                }
            }
        }
        .onAppear {
            focus = true
            if viewModel.notificationManager.timeInterval != 0 {
                isDateFailureEntered = date - Double(viewModel.notificationManager.timeInterval) < Date()
            }
        }
    }
    
    private var cancelButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Cancel")
        }
    }
    
    private var doneButton: some View {
        Button {
            if viewModel.notificationManager.timeInterval != 0 {
                isDateFailureEntered = date - Double(viewModel.notificationManager.timeInterval) < Date()
            }
            if !title.isEmpty && !isDateFailureEntered {
                let task = ToDoTask(title: title,
                                    description: description,
                                    date: date,
                                    tag: tag)
                viewModel.coreDataManager.saveData(task: task)
                viewModel.toDoTasks = viewModel.coreDataManager.getData().sorted { $0.date < $1.date }
                viewModel.notificationManager.sendNotification(date: task.date, title: task.title, body: task.description)
                dismiss()
            }
        } label: {
            Text("Done")
                .font(.body.bold())
                .foregroundColor(title.isEmpty || isDateFailureEntered ? Color(uiColor: .secondaryLabel) : Color(uiColor: .tintColor))
        }
    }
    
    private var titleView: some View {
        TextField("Enter task title", text: $title)
            .focused($focus)
    }
    
    private var descriptionView: some View {
        ZStack {
            if description.isEmpty {
                Text("Description (Optional)")
                    .foregroundColor(Color(uiColor: .tertiaryLabel))
            }
            TextEditor(text: $description)
                .frame(height: 80)
        }
    }
    
    private var dateView: some View {
        VStack {
            DatePicker(selection: $date, displayedComponents: [.date, .hourAndMinute]) {
                Text("Select date and time")
                    .foregroundColor(Color(uiColor: .tertiaryLabel))
            }
            .datePickerStyle(.compact)
            .onChange(of: date) { newValue in
                if viewModel.notificationManager.timeInterval != 0 {
                    isDateFailureEntered = newValue - Double(viewModel.notificationManager.timeInterval) < Date()
                }
            }
            if isDateFailureEntered {
                if viewModel.notificationManager.timeInterval != 0 {
                    let minimalDate = Date() + Double(viewModel.notificationManager.timeInterval) + 60
                    Text("Minimal date to set - \(minimalDate.stringDate) \(minimalDate.stringTime)")
                        .foregroundColor(.red)
                    Text("You can change it in notifications settings in application")
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
            }
        }
    }
    
    private var tagView: some View {
        Picker(selection: $tag) {
            Text("Important!")
                .foregroundColor(.red)
                .font(.body.bold())
                .tag(Tag.important)
            Text("Normal")
                .foregroundColor(.blue)
                .tag(Tag.normal)
            Text("Indifferently")
                .tag(Tag.indifferently)
        } label: {
            Text("Tag")
        }
    }
}

struct A_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(viewModel: ToDoViewModel(coreDataManager: CoreDataManager(name: "Model"), notificationManager: NotificationManager(), userDefaultManager: UserDefaultManafer()))
    }
}

