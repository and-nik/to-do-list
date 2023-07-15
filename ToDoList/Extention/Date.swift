//
//  Date.swift
//  ToDoList
//
//  Created by And Nik on 13.07.23.
//

import Foundation

extension Date {
    
    public var stringDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.yyyy"
        let stringDate = formatter.string(from: self)
        return stringDate
    }
    
    public var stringTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let stringDate = formatter.string(from: self)
        return stringDate
    }
    
    public var stringDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let stringDate = formatter.string(from: self)
        return stringDate
    }
    
    public var stringMonthAndDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, d"
        let stringDate = formatter.string(from: self)
        return stringDate
    }
}
