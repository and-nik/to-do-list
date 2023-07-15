//
//  EditView.swift
//  ToDoList
//
//  Created by And Nik on 14.07.23.
//

import SwiftUI

struct EditView: View {
    
    @State private var title = ""
    @State private var description = ""
    @State private var tag: Tag = .normal
    @State var task: ToDoTask
    
    @Environment(\.dismiss) var dismiss
    
    var completion: (ToDoTask) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    dateView
                }
                Section {
                    titleView
                } header: {
                    Text("Title")
                }
                Section {
                    descriptionView
                } header: {
                    Text("Desctiption")
                }
                tagView
            }
            .navigationBarTitle("Edit task", displayMode: .inline)
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
            title = task.title
            description = task.description
            tag = task.tag
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
            if !title.isEmpty {
                let newTask = ToDoTask(title: title,
                                       description: description,
                                       date: task.date,
                                       status: task.status, tag: tag,
                                       isFavorite: task.isFavorite)
                completion(newTask)
                dismiss()
            }
        } label: {
            Text("Done")
                .font(.body.bold())
                .foregroundColor(Color(uiColor: .tintColor))
        }
    }
    
    private var titleView: some View {
        TextEditor(text: $title)
    }
    
    private var descriptionView: some View {
        ZStack {
            if description.isEmpty {
                Text(task.description.isEmpty ? "Description (Optional)" : task.description)
                    .foregroundColor(Color(uiColor: .tertiaryLabel))
            }
            TextEditor(text: $description)
                .frame(height: 80)
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
    
    private var dateView: some View {
        HStack {
            Text("Date and Time")
            Spacer()
            Image(systemName: "lock")
                .foregroundColor(Color(uiColor: .systemGray))
            Text(task.date.stringDate + " " + task.date.stringTime)
                .foregroundColor(Color(uiColor: .systemGray))
        }
    }
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        let task = ToDoTask(title: "gg", description: "hh", date: Date(), tag: .important)
        EditView(task: task) { _ in
            
        }
    }
}
