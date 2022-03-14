//
//  TaskListRouter.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import UIKit

protocol TaskListRoutingLogic {
    func showNewTask()
    func showTaskDetailsScreen(taskID: Int)
}

class TaskListRouter: TaskListRoutingLogic {
    
    weak var viewController: UIViewController?
    var dataSource: TaskListDataSource?
    
    func showNewTask() {
        guard let newTask = dataSource?.newTask else { return }
        let taskDetailsViewController = TaskDetailsViewController()
        taskDetailsViewController.displayTask(newTask)
        viewController?.present(taskDetailsViewController, animated: true, completion: nil)
    }
    
    func showTaskDetailsScreen(taskID: Int) {
        guard let dataSource = dataSource, let task = dataSource.tasks.element(with: taskID) else { return }
        let taskDetailsViewController = TaskDetailsViewController()
        viewController?.present(taskDetailsViewController, animated: true, completion: nil)
        taskDetailsViewController.displayTask(task)
    }
}
