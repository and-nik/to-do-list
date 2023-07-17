//
//  FavoriteTaskView.swift
//  ToDoList
//
//  Created by And Nik on 15.07.23.
//

import SwiftUI

struct FavoriteTaskView: View {
    
    private let task: ToDoTask
    
    init(task: ToDoTask) {
        self.task = task
    }
    
    var body: some View {
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
                    }
                    .background(!task.status ? Color(UIColor.systemYellow).opacity(0.6) : .clear)
                    .cornerRadius(10)
                    .padding(.vertical, 5)
                    .padding(.trailing, 5)
                }
                tagView
            }
        }
        .padding(.leading, 25)
        .padding(.trailing, 20)
    }
    
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
            Rectangle()
                .fill(.secondary)
                .frame(width: 3)
        }
    }
    
    private var timeView: some View {
        HStack {
            Text(task.date.stringDate + " " + task.date.stringTime)
                .foregroundStyle(task.date < Date() ? .red : .secondary)
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
