//
//  TaskViewModelFactory.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 13.03.2022.
//

import Foundation

class TaskViewModelFactory {
    
    static func makeTaskViewModels(from tasks: [Task], on date: Date) -> [TaskViewModel] {
        tasks.filter({$0.appearsOnDate(date)}).map { task in
            let isDone = task.isDoneOnDate(date)
            return TaskViewModel(id: task.id, orderID: task.orderID, title: task.title, isDone: isDone, notificationTime: task.notificationTime, color: task.color)
        }
    }
}
