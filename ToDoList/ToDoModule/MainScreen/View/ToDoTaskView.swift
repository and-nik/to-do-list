//
//  ToDoTaskView.swift
//  ToDoList
//
//  Created by And Nik on 13.07.23.
//

import SwiftUI

struct ToDoTaskView: View {
    
    @State var task: ToDoTask
    @State var isDeleted: Bool = false
    @State var isEditViewPresented: Bool = false
    
    var isEditing: Bool = false
    var coreDataManager: CoreDataManagerProtocol
    var completion: () -> Void
    
    var body: some View {
        //GeometryReader { geometry in
            HStack {
                leadingStatusView
                VStack(spacing: 0) {
                    timeView
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            titleView
                            
                            if task.description != "" {
                                Divider()
                                descriptionView
                            }
                            Divider()
                            
                            if !task.status {
                                buttonView
                            }
                        }
                        .background(!task.status ? Color(UIColor.systemGray5) : .clear)
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                        .padding(.trailing, 5)
                        
                        if isEditing {
                            trailingDeleteButton
                        }
                    }
                    tagView
                }
            }
            .padding(.leading, 25)
            .padding(.trailing, 20)
            //.offset(x: isDeleted ? geometry.size.width * -2 : 0)
            .offset(x: isDeleted ? UIScreen.main.bounds.width * -2 : 0)
        }
    //}
    
    private var leadingStatusView: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(task.status ? LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .bottomLeading, endPoint: .topTrailing) : LinearGradient(gradient: Gradient(colors: [.clear]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 12, height: 12)
                .background(
                    Circle()
                        .stroke(.secondary, lineWidth: 1)
                        .padding(-3))
                .padding(.top, 4)
                .onTapGesture {
                    withAnimation {
                        task.status.toggle()
                        coreDataManager.update(task: task)
                        completion()
                    }
                }
            Rectangle()
                .fill(.secondary)
                .frame(width: 3)
        }
    }
    
    private var trailingDeleteButton: some View {
        Button {
            withAnimation(.spring(dampingFraction: 0.75)) {
                isDeleted.toggle()
            }
            coreDataManager.delete(task: task)
            completion()
        } label: {
            Image(systemName: "minus.circle.fill")
                .font(.title2.bold())
                .foregroundColor(.red)
        }
        .padding(10)
    }
    
    private var timeView: some View {
        HStack {
            Text(task.date.stringTime)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private var titleView: some View {
        HStack {
            Text(task.title)
                .font(.title3.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, task.status ? 3 : 10)
            Spacer()
            favoriteButton
            if isEditing {
                editButton
                    .padding(.trailing)
            }
        }
    }
    
    private var editButton: some View {
        Button {
            isEditViewPresented.toggle()
        } label: {
            Image(systemName: "square.and.pencil")
        }
        .sheet(isPresented: $isEditViewPresented) {
            EditView(task: task) {
                task = $0
                coreDataManager.update(task: task)
                completion()
            }
        }
    }
    
    private var favoriteButton: some View {
        Button {
            task.isFavorite.toggle()
            coreDataManager.update(task: task)
            completion()
        } label: {
            Image(systemName: task.isFavorite ? "bookmark.fill" : "bookmark")
                .foregroundColor(.yellow)
                .padding(.trailing)
        }
    }
    
    private var descriptionView: some View {
        HStack {
            Text(task.description)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
                .padding(.vertical, task.status ? 3 : 10)
            Spacer()
        }
    }
    
    private var buttonView: some View {
        HStack {
            Circle()
                .stroke(.secondary, lineWidth: 1)
                .frame(width: 20, height: 20)
            Text("Tap here if task done")
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color(UIColor.systemGray5))
        .onTapGesture {
            withAnimation {
                task.status.toggle()
                coreDataManager.update(task: task)
                completion()
            }
        }
    }
    
    private var tagView: some View {
        HStack {
            switch task.tag {
            case .important:
                Circle()
                    .fill(task.status ? Color(UIColor.tertiaryLabel) : .red)
                    .font(.body.bold())
                    .frame(width: 10, height: 10)
                Text("Important!")
                    .foregroundColor(task.status ? Color(UIColor.tertiaryLabel) : .red)
                    .font(.body.bold())
            case .indifferently:
                Circle()
                    .fill(Color(UIColor.tertiaryLabel))
                    .frame(width: 10, height: 10)
                Text("indifferently")
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            default:
                EmptyView()
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
}
