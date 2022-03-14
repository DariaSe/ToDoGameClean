//
//  TaskViewModel.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import Foundation

struct TaskViewModel: Identifiable {
    
    var id: Int
    var orderID: Int
    var title: String
    var isDone: Bool
    var notificationTime: String?
    var color: Int?
    
    static var sample: [TaskViewModel] { [
        TaskViewModel(id: 1, orderID: 1, title: "Task 1", isDone: true, color: 2),
        TaskViewModel(id: 2, orderID: 2, title: "Task 2", isDone: false, color: 6),
        TaskViewModel(id: 3, orderID: 3, title: "Task 3", isDone: false, color: 8),
        TaskViewModel(id: 4, orderID: 4, title: "Task 4", isDone: true, color: 2)
    ] }
}

extension TaskViewModel: Comparable {
    
    static func < (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.orderID < rhs.orderID
    }
    
    static func == (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
}

