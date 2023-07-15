//
//  ContentView.swift
//  ToDoList
//
//  Created by And Nik on 12.07.23.
//

import SwiftUI

struct ToDoView<ViewModelProtocol>: View where ViewModelProtocol: ToDoViewModelProtocol {
    
    @StateObject private var viewModel: ViewModelProtocol
    
    @Namespace var dayAnimation
    @Namespace var monthAnimation
    @Namespace var yearAnimation
    
    @State var isYearsTaped: Bool = false
    @State var isMonthTaped: Bool = false
    @State var isAddTasksViewPresented: Bool = false
    @State var isEditing: Bool = false
    
    init(viewModel: ViewModelProtocol) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        TabView {
            NavigationView {
                ScrollView {
                    VStack {
                        yearButton
                        monthsButton
                        tasksSection
                    }
                }
                .navigationTitle(viewModel.selectedDate.stringDate == Date().stringDate ? "Today" : viewModel.selectedDate.stringDate)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        todayButton
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        editButton
                        addTaskButton
                    }
                }
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("List")
            }
            FavoriteView(tasks: viewModel.toDoTasks)
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Favorite")
                }
        }
        .onAppear {
            viewModel.toDoTasks = viewModel.coreDataManager.getData().sorted { $0.date < $1.date }
        }
        
    }
    
    private var yearButton: some View {
        VStack(spacing: 0) {
            let dateComp = Calendar.current.dateComponents([.year], from: viewModel.selectedDate)
            
            //MARK: - Expanding button...
            
            Button {
                withAnimation(.spring(dampingFraction: 0.7)) {
                    self.isYearsTaped.toggle()
                }
            } label: {
                
                Text(String(dateComp.year ?? 0))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .font(.title3.bold())
                    .padding(5)
            }
            
            Divider()
            
            //MARK: - All years list...
            
            let colums = Array(repeating: GridItem(.flexible()), count: 4)
            
            LazyVGrid(columns: colums) {
                ForEach(viewModel.years, id: \.self) { year in
                    Text(String(year))
                        .onTapGesture {
                            viewModel.setYear(year: year)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .foregroundColor(dateComp.year == year ? Color(UIColor.systemBackground) : Color(UIColor.label))
                        .background {
                            if dateComp.year == year {
                                Capsule()
                                    .fill(Color(UIColor.label))
                                    .matchedGeometryEffect(id: "year", in: yearAnimation)
                            } else {
                                Capsule()
                                    .fill(Color(UIColor.systemBackground))
                            }
                        }
                        .contentShape(Capsule())
                        .animation(Animation.spring(dampingFraction: 0.75), value: viewModel.selectedDate)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .frame(height: isYearsTaped ? nil : 0, alignment: .top)
            .clipped()
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
    
    private var monthsButton: some View {
        let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: viewModel.selectedDate)
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        return VStack(spacing: 0) {
            
            //MARK: - Expanding button...
            
            Button {
                withAnimation(.spring(dampingFraction: 0.75)) {
                    isMonthTaped.toggle()
                }
            } label: {
                Text(viewModel.selectedDate.stringMonthAndDay)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .font(.title3.bold())
                    .padding(5)
            }
            
            Divider()
            
            //MARK: - Calender Mons list...
            
            VStack(spacing: 0) {
                ScrollViewReader { value in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(Array(months.enumerated()), id: \.offset) { index, month in
                                Text(month)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 5)
                                    .foregroundColor(dateComp.month == index+1 ? Color(UIColor.systemBackground) : Color(UIColor.label))
                                    .background {
                                        if dateComp.month == index+1 {
                                            Capsule()
                                                .fill(Color(UIColor.label))
                                                .matchedGeometryEffect(id: "month", in: monthAnimation)
                                        } else {
                                            Capsule()
                                                .fill(Color(UIColor.systemBackground))
                                        }
                                    }
                                    .contentShape(Capsule())
                                    .onTapGesture {
                                        viewModel.setMonth(month: index + 1)
                                    }
                                    .onChange(of: viewModel.selectedDate) { _ in
                                        let newDateComp = Calendar.current.dateComponents([.year, .month, .day], from: viewModel.selectedDate)
                                        let someMonth = newDateComp.month ?? 1
                                        withAnimation {
                                            value.scrollTo(someMonth - 1, anchor: .center)
                                        }
                                    }
                                    .animation(Animation.spring(dampingFraction: 0.75), value: viewModel.selectedDate)
                                    .id(index)
                            }
                            .onAppear {
                                let newDateComp = Calendar.current.dateComponents([.year, .month, .day], from: viewModel.selectedDate)
                                let someMonth = newDateComp.month ?? 1
                                withAnimation {
                                    value.scrollTo(someMonth - 1, anchor: .center)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .opacity(self.isMonthTaped ? 1 : 0)
                }
                
                Divider()
                
                //MARK: - Days list...
                
                let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                HStack {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .opacity(self.isMonthTaped ? 1 : 0)
                
                Divider()
                
                //MARK: - All days in month list...
                
                let colums = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: colums, spacing: 0) {
                    ForEach(Array(viewModel.getCorrectlyDisplacedDaysInMonth().enumerated()), id: \.offset) { index, day in
                        let dayDateComp = Calendar.current.dateComponents([.year], from: day)
                        if dayDateComp.year ?? 0 == 1 {
                            Text("")
                        } else {
                            ZStack {
                                VStack(spacing: 3) {
                                    Text("\(day.stringDay)")
                                    if viewModel.getTasksInDay(day: day).isEmpty {
                                        Spacer()
                                    } else {
                                        Circle()
                                            .fill()
                                            .frame(width: 8, height: 8)
                                    }
                                }
                            }
                            .frame(width: 25, height: 35)
                            .padding(3)
                            .foregroundColor(viewModel.selectedDate.stringDate == day.stringDate ? Color(UIColor.systemBackground) : Color(UIColor.label))
                            .onTapGesture {
                                let dayDateComp = Calendar.current.dateComponents([.day], from: day)
                                withAnimation(.spring(dampingFraction: 0.75)) { viewModel.setDayTo(day: dayDateComp.day ?? 1) }
                            }
                            .background {
                                if viewModel.selectedDate.stringDate == day.stringDate {
                                    Capsule()
                                        .fill(Color(UIColor.label))
                                        .matchedGeometryEffect(id: "day", in: dayAnimation)
                                }
                            }
                            .contentShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .opacity(self.isMonthTaped ? 1 : 0)
            }
            .frame(height: isMonthTaped ? nil : 0, alignment: .top)
            .clipped()
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
    
    private var tasksSection: some View {
        VStack {
            if viewModel.getTasksInDay(day: viewModel.selectedDate).isEmpty {
                Text("No tasks for this day")
                    .frame(alignment: .center)
                    .padding(.top, 60)
            } else {
                ForEach(Array(viewModel.toDoTasks.enumerated()), id: \.element) { index, task in
                    if task.date.stringDate == viewModel.selectedDate.stringDate {
                        ToDoTaskView(task: task, isEditing: isEditing, coreDataManager: viewModel.coreDataManager) {
                            withAnimation {
                                viewModel.toDoTasks = viewModel.coreDataManager.getData().sorted { $0.date < $1.date }
                            }
                        }
                    }
                    
                }
            }
        }
        
    }
    
    private var addTaskButton: some View {
        Button {
            isAddTasksViewPresented.toggle()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color(uiColor: .tintColor))
                    .font(.body.bold())
                Text("Add task")
                    .foregroundColor(Color(uiColor: .tintColor))
                    .font(.body.bold())
            }
        }
        .sheet(isPresented: $isAddTasksViewPresented) {
            AddTaskView(viewModel: viewModel)
        }
    }
    
    private var todayButton: some View {
        Button {
            viewModel.selectedDate = Date()
        } label: {
            Text("Today")
        }
    }
    
    private var editButton: some View {
        Button {
            withAnimation {
                isEditing.toggle()
            }
        } label: {
            Image(systemName: isEditing ? "pencil.circle.fill" : "pencil.circle")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView(viewModel: ToDoViewModel(coreDataManager: CoreDataManager(name: "Model")))
    }
}
