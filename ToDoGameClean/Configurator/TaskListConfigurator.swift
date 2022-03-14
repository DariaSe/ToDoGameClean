//
//  TaskListConfigurator.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import Foundation

final class TaskListConfigurator {
    
    static let shared = TaskListConfigurator()
    
    private init() {}
    
    func configure(viewController: TaskListViewController) {
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter()
        let router = TaskListRouter()
        let repository = TasksRepository()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.repository = repository
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataSource = interactor
    }
}
