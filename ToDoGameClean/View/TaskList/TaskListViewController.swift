//
//  TaskListViewController.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import UIKit

protocol TaskListDisplayLogic: AnyObject {
    func displayTasks(_ tasks: [TaskViewModel])
}

protocol CalendarDisplayLogic {
    func displayDate(_ dateString: String)
    func displayCalendar(_ calendarDays: [CalendarDay])
    func hideCalendar()
}

final class TaskListViewController: UIViewController {
    
    var interactor : (TaskListInteractorLogic & CalendarInteractorLogic)?
    var router : TaskListRoutingLogic?
    
    private let calendarHeaderView = CalendarHeaderView()
    private let calendarView = CalendarCollectionView()
    private var calendarHeightConstraint = NSLayoutConstraint()
    
    private let addButton = UIButton()
    private let plusImage = UIImage(named: "Plus")?.withRenderingMode(.alwaysTemplate)
    
    private let taskListView = TaskListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getTasks()
        setupSubviews()
        calendarView.didSelectDate = { [unowned self] newDate in
            interactor?.setDate(newDate)
        }
        taskListView.didSelectTask = { [unowned self] taskID in
            router?.showTaskDetailsScreen(taskID: taskID)
        }
        taskListView.toggleTaskCompletion = { [unowned self] taskID in
            interactor?.toggleTaskCompletion(taskID: taskID)
        }
        taskListView.deleteTask = { [unowned self] taskID in
            interactor?.deleteTask(taskID: taskID)
        }
    }
    
    private func setupSubviews() {
        view.backgroundColor = UIColor.backgroundColor
        view.pinToLayoutMargins(subview: calendarHeaderView, leading: 30, trailing: 30, top: 0, bottom: nil)
        calendarHeaderView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.pinToLayoutMargins(subview: addButton, leading: nil, trailing: -10, bottom: nil)
        addButton.setDimensions(width: 50, height: 50)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
//        view.pinToLayoutMargins(subview: gamificationOverview, top: nil, bottom: nil)
        calendarView.topAnchor.constraint(equalTo: calendarHeaderView.bottomAnchor, constant: 10).isActive = true
//        calendarView.bottomAnchor.constraint(equalTo: gamificationOverview.topAnchor, constant: -5).isActive = true
        view.pinToEdges(subview: taskListView, top: nil)
        calendarView.bottomAnchor.constraint(equalTo: taskListView.topAnchor, constant: -5).isActive = true
        
//        gamificationOverview.bottomAnchor.constraint(equalTo: taskListView.topAnchor).isActive = true
        calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendarView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        calendarHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 0)
        calendarHeightConstraint.isActive = true
        calendarView.alpha = 0.0
        
        calendarHeaderView.delegate = interactor
        calendarHeaderView.title = Date().formattedForHeader
        
        addButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        addButton.setImage(plusImage, for: .normal)
        addButton.tintColor = UIColor.buttonColor
    }
    
    @objc func addTask() {
        router?.showNewTask()
    }
}

// MARK: - TaskListDisplayLogic

extension TaskListViewController: TaskListDisplayLogic {
    func displayTasks(_ tasks: [TaskViewModel]) {
        taskListView.tasks = tasks
    }
}

// MARK: - CalendarDisplayLogic

extension TaskListViewController: CalendarDisplayLogic {
    func displayDate(_ dateString: String) {
        calendarHeaderView.title = dateString
    }
    
    func displayCalendar(_ calendarDays: [CalendarDay]) {
        let numberOfWeeks = calendarDays.count / 7
        let calendarHeight = CGFloat(40 * numberOfWeeks + 6 * (numberOfWeeks - 1) + 1 + 16)
        UIView.animate(withDuration: 0.2) {
            self.calendarHeightConstraint.constant = calendarHeight
            self.calendarView.alpha = 1.0
            self.calendarView.isCalendarShown = true
        }
        calendarView.dataSource = calendarDays
    }
    
    func hideCalendar() {
        UIView.animate(withDuration: 0.2) {
            self.calendarHeightConstraint.constant = 0
            self.calendarView.alpha = 0.0
            self.calendarView.isCalendarShown = false
        }
    }
}
