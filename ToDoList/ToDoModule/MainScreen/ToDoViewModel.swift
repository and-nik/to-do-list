//
//  ToDoViewModel.swift
//  ToDoList
//
//  Created by And Nik on 12.07.23.
//

import SwiftUI

protocol ToDoViewModelProtocol: ObservableObject {
    
    var coreDataManager: CoreDataManagerProtocol { get set }
    var notificationManager: NotificationManagerProtocol { get set }
    var userDefaultManager: UserDefaultManaferProtocol { get set }
    
    var toDoTasks: [ToDoTask] { get set }
    var selectedDate: Date { get set }
    var years: [Int] { get }
    
    func getCorrectlyDisplacedDaysInMonth() -> [Date]
    func getTasksInDay(day: Date) -> [ToDoTask]
    func setYear(year: Int)
    func setMonth(month: Int)
    func setDayTo(day: Int)
}

final class ToDoViewModel: ToDoViewModelProtocol {
    
    var coreDataManager: CoreDataManagerProtocol
    var notificationManager: NotificationManagerProtocol
    var userDefaultManager: UserDefaultManaferProtocol
    
    @Published public var toDoTasks: [ToDoTask] = []
    @Published public var selectedDate: Date = Date()
    
    public var years: [Int] {
        Array(Set(toDoTasks.compactMap {
            let dateComp = Calendar.current.dateComponents([.year], from: $0.date)
            return dateComp.year
        })).sorted(by: <)//убрать дубликаты годов
    }
    
    init(coreDataManager: CoreDataManagerProtocol, notificationManager: NotificationManagerProtocol, userDefaultManager: UserDefaultManaferProtocol) {
        self.coreDataManager = coreDataManager
        self.notificationManager = notificationManager
        self.userDefaultManager = userDefaultManager
    }
    
    private func getDaysInMonth() -> [Date] {
        let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        guard let range = Calendar.current.range(of: .day, in: .month, for: selectedDate) else {return []}
        let dates = range.compactMap {
            guard let year = dateComp.year,
                  let month = dateComp.month else { return Date()}
            return DateComponents(calendar: Calendar.current, year: year, month: month, day: $0).date
        }
        return dates
    }
    
    public func getCorrectlyDisplacedDaysInMonth() -> [Date] {
        var dates = getDaysInMonth()
        var dateComp = DateComponents()
        dateComp.year = 1
        dateComp.month = 1
        dateComp.day = 1
        let fakeDate = Calendar.current.date(from: dateComp)
        guard let firstDate = dates.first else { return []}
        var firstWeekday = Calendar.current.component(.weekday, from: firstDate)
        
        switch firstWeekday {
        case 1: firstWeekday = 6
        case 2: firstWeekday = 7
        case 3: firstWeekday = 1
        case 4: firstWeekday = 2
        case 5: firstWeekday = 3
        case 6: firstWeekday = 4
        case 7: firstWeekday = 5
        default: break
        }//сделать начало отсчета с пн
        
        if firstWeekday != 7 {
            (0..<firstWeekday).forEach { _ in
                dates.insert(fakeDate ?? Date(), at: 0)
            }
        }
        return dates
    }
    
    public func getTasksInDay(day: Date) -> [ToDoTask] {
        var tasksInDay = [ToDoTask]()
        toDoTasks.forEach { task in
            let dateComp = Calendar.current.dateComponents([.year, .month, .day], from: day)
            let taskDateComp = Calendar.current.dateComponents([.year, .month, .day], from: task.date)
            if dateComp.year == taskDateComp.year &&
                dateComp.month == taskDateComp.month &&
                dateComp.day == taskDateComp.day {
                tasksInDay.append(task)
            }
        }
        return tasksInDay
    }
    
    public func setYear(year: Int) {
        var selectedDateComp = Calendar.current.dateComponents([.year, .month], from: selectedDate)
        selectedDateComp.year = year
        selectedDate = Calendar.current.date(from: selectedDateComp) ?? Date()
    }
    
    public func setMonth(month: Int) {
        var selectedDateComp = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        selectedDateComp.day = 1
        selectedDateComp.month = month
        selectedDate = Calendar.current.date(from: selectedDateComp) ?? Date()
    }
    
    public func setDayTo(day: Int) {
        var selectedDateComp = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        selectedDateComp.day = day
        selectedDate = Calendar.current.date(from: selectedDateComp) ?? Date()
    }
}
