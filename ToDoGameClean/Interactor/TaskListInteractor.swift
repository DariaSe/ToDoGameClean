//
//  TaskListInteractor.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import Foundation

protocol TaskListInteractorLogic {
    func getTasks()
    func toggleTaskCompletion(taskID: Int)
    func deleteTask(taskID: Int)
}

protocol TaskListDataSource {
    var tasks: [Task] { get set }
    var newTask: Task { get }
}

protocol CalendarInteractorLogic {
    func setDate(_ newDate: Date)
    func setNext()
    func setPrevious()
    func showHideCalendar()
}



final class TaskListInteractor: TaskListInteractorLogic, TaskListDataSource, CalendarInteractorLogic {
    
    var presenter: (TaskListPresentationLogic & DeletionAlertPresentationLogic & ErrorPresentationLogic & CalendarPresentationLogic)?
    var repository: TasksRepositoryLogic?
    
    var tasks: [Task] = []
    var newTask: Task {
        let nextOrderID = tasks.map({$0.orderID}).sorted().last ?? 1
        return Task.newTask(orderID: nextOrderID, date: date)
    }
    
    // MARK: - TaskListInteractorLogic
    
    func getTasks() {
        repository?.getTasks(completion: { [unowned self] tasks, error in
            DispatchQueue.main.async {
                if let tasks = tasks {
                    self.tasks = tasks
                    presenter?.presentTasks(tasks, on: date)
                }
                if let error = error {
                    presenter?.presentError(error)
                }
            }
        })
    }
    
    func toggleTaskCompletion(taskID: Int) {
        repository?.toggleTaskCompletion(taskID: taskID, date: date, completion: { [unowned self] success, error in
            DispatchQueue.main.async {
                if success {
                    InMemoryTasksWorker.toggleTaskCompletion(taskID: taskID, in: &tasks, on: date)
                    presenter?.presentTasks(tasks, on: date)
                }
                if let error = error {
                    presenter?.presentError(error)
                }
            }
        })
    }
    
    func deleteTask(taskID: Int) {
        presenter?.presentDeletionAlert { [unowned self] in
            repository?.deleteTask(taskID: taskID, completion: { success, error in
                DispatchQueue.main.async {
                    if success {
                        InMemoryTasksWorker.deleteTask(taskID: taskID, in: &tasks)
                        presenter?.presentTasks(tasks, on: date)
                    }
                    if let error = error {
                        presenter?.presentError(error)
                    }
                }
            })
        }
    }
    
    // MARK: - CalendarInteractorLogic
    
    var date: Date = Date()
    var isCalendarShown: Bool = false
    
    func setDate(_ newDate: Date) {
        date = newDate
        isCalendarShown = false
        presenter?.presentFullDate(date)
        presenter?.presentCalendar(containing: date)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.presenter?.hideCalendar()
            self.presenter?.presentTasks(self.tasks, on: self.date)
        }
    }
    
    func setNext() {
        if isCalendarShown {
            date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
            presenter?.presentMonthAndYear(date)
            presenter?.presentCalendar(containing: date)
        }
        else {
            date = date.tomorrow
            presenter?.presentFullDate(date)
            presenter?.presentTasks(tasks, on: date)
        }
    }
    
    func setPrevious() {
        if isCalendarShown {
            date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
            presenter?.presentMonthAndYear(date)
            presenter?.presentCalendar(containing: date)
        }
        else {
            date = date.yesterday
            presenter?.presentFullDate(date)
            presenter?.presentTasks(tasks, on: date)
        }
    }
    
    func showHideCalendar() {
        isCalendarShown.toggle()
        if isCalendarShown {
            presenter?.presentMonthAndYear(date)
            presenter?.presentCalendar(containing: date)
        }
        else {
            presenter?.presentFullDate(date)
            presenter?.hideCalendar()
        }
    }
}
