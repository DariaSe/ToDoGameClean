//
//  TaskListPresenter.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import UIKit

protocol TaskListPresentationLogic {
    func presentTasks(_ tasks: [Task], on date: Date)
}

protocol DeletionAlertPresentationLogic {
    func presentDeletionAlert(onDelete: @escaping () -> ())
}

protocol ErrorPresentationLogic {
    func presentError(_ error: Error)
}

protocol CalendarPresentationLogic {
    func presentFullDate(_ date: Date)
    func presentMonthAndYear(_ date: Date)
    func presentCalendar(containing date: Date)
    func hideCalendar()
}

final class TaskListPresenter: TaskListPresentationLogic {
    
    weak var viewController: (TaskListDisplayLogic & ErrorDisplayLogic & DeletionAlertDisplayLogic & CalendarDisplayLogic)?
    
    func presentTasks(_ tasks: [Task], on date: Date) {
        let viewModels = TaskViewModelFactory.makeTaskViewModels(from: tasks, on: date)
        viewController?.displayTasks(viewModels)
    }
}

extension TaskListPresenter: DeletionAlertPresentationLogic {
    func presentDeletionAlert(onDelete: @escaping () -> ()) {
        let title = Strings.taskDeletionTitle
        let message = Strings.taskDeletionMessage
        viewController?.displayDeletionAlert(title: title, message: message, onDelete: onDelete)
    }
}

extension TaskListPresenter: ErrorPresentationLogic {
    func presentError(_ error: Error) {
        viewController?.displayError(error.localizedDescription)
    }
}

extension TaskListPresenter: CalendarPresentationLogic {
    
    func presentFullDate(_ date: Date) {
        let dateString = date.formattedForHeader
        viewController?.displayDate(dateString)
    }
    
    func presentMonthAndYear(_ date: Date) {
        let dateString = date.monthAndYear
        viewController?.displayDate(dateString)
    }
    
    func presentCalendar(containing date: Date) {
        let calendarDays = CalendarService.makeCalendarDays(containing: date)
        viewController?.displayCalendar(calendarDays)
    }
    
    func hideCalendar() {
        viewController?.hideCalendar()
    }
}
