//
//  TaskDetailsViewController.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import UIKit

protocol TaskDetailsDisplayLogic {
    func displayTask(_ task: Task)
}

class TaskDetailsViewController: UIViewController {
    
    var task: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

        // Do any additional setup after loading the view.
    }
}

extension TaskDetailsViewController: TaskDetailsDisplayLogic {
    func displayTask(_ task: Task) {
        
    }
}
