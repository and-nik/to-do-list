//
//  Tag.swift
//  ToDoList
//
//  Created by And Nik on 12.07.23.
//

import Foundation

enum Tag: Int, Codable {
    case important = 0
    case normal = 1
    case indifferently = 2//посредственно
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .important
        case 1: self = .normal
        case 2: self = .indifferently
        default: self = .normal
        }
    }
}
