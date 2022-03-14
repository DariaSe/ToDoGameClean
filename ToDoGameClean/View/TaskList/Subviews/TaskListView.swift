//
//  TaskListView.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import UIKit

final class TaskListView: UIView {
    
    var swapDelegate: SwapDelegate?
    
    var tasks: [TaskViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var activeTasks: [TaskViewModel] { tasks.filter { !$0.isDone } }
    private var completedTasks: [TaskViewModel] { tasks.filter { $0.isDone } }
 
    var toggleTaskCompletion: ((Int) -> Void)?
    var deleteTask: ((Int) -> Void)?
    var didSelectTask: ((Int) -> Void)?
    
    private var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private var snapshotView = UIImageView()
    
    private let longPressRecognizer = UILongPressGestureRecognizer()
    private var sourceIndexPath: IndexPath?
    private var firstTaskID: Int?
    private var secondTaskID: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        self.pinToEdges(subview: tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        tableView.addGestureRecognizer(longPressRecognizer)
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.addTarget(self, action: #selector(handleLongPressGesture(_:)))
        tableView.addSubview(snapshotView)
    }
    
    func animateCompletion(at indexPath: IndexPath, completion: @escaping (() -> Void)) {
        guard indexPath.section == 0 else { completion(); return }
        let cell = self.tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        let task = activeTasks[indexPath.row]
        cell.update(title: task.title, isDone: true, color: task.color)
        let snapshot = cell.taskView.snapshot
        snapshotView.image = snapshot
        snapshotView.frame = cell.frame
        UIView.animate(withDuration: 0.1) {
            self.snapshotView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { (_) in
            UIView.animate(withDuration: 0.1) {
                self.snapshotView.transform = CGAffineTransform.identity
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.snapshotView.frame = CGRect.zero
            completion()
        }
    }
    
    @objc private func handleLongPressGesture(_ recognizer: UILongPressGestureRecognizer) {
        
        let location = recognizer.location(in: tableView)
        let newIndexPath = tableView.indexPathForRow(at: location)
        
        guard let indexPath = newIndexPath else {
            recognizer.cancel()
            snapshotView.transform = CGAffineTransform.identity
            let cell = tableView.cellForRow(at: sourceIndexPath!) as! TaskTableViewCell
            cell.containerView.isHidden = false
            cell.placeholderView.isHidden = true
            snapshotView.frame = CGRect.zero
            return
        }
        
        switch recognizer.state {
        case .began:
            guard indexPath.section != 1 else {
                recognizer.cancel()
                return
            }
            swapDelegate?.beginSwapping()
            tableView.bringSubviewToFront(snapshotView)
            sourceIndexPath = indexPath
            let task = activeTasks[indexPath.row]
            firstTaskID = task.id
            let cell = self.tableView.cellForRow(at: indexPath) as! TaskTableViewCell
            let snapshot = cell.taskView.snapshot
            snapshotView.image = snapshot
            snapshotView.frame = cell.frame
            UIView.animate(withDuration: 0.1) {
                self.snapshotView.transform = CGAffineTransform(rotationAngle: 0.05)
            }
            cell.containerView.isHidden = true
            cell.placeholderView.isHidden = false
            
        case .changed:
            guard indexPath.section != 1 else {
                recognizer.cancel()
                if let sourceIndexPath = sourceIndexPath {
                    cleanUp(at: sourceIndexPath)
                }
                return
            }
            snapshotView.center.y = location.y
            if indexPath != sourceIndexPath {
                tableView.moveRow(at: sourceIndexPath!, to: indexPath)
                secondTaskID = activeTasks[indexPath.row].id
                if let firstID = firstTaskID, let secondID = secondTaskID, firstID != secondID {
                    swapDelegate?.swap(firstID: firstID, secondID: secondID)
                }
                sourceIndexPath = indexPath
            }
            
        case .ended:
            swapDelegate?.endSwapping()
            cleanUp(at: indexPath)
            
        default:
            if let sourceIndexPath = sourceIndexPath {
                cleanUp(at: sourceIndexPath)
            }
            tableView.reloadData()
        }
    }
    
    private func cleanUp(at indexPath: IndexPath) {
        guard indexPath.section != 1 else { return }
        snapshotView.transform = CGAffineTransform.identity
        let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        cell.containerView.isHidden = false
        cell.placeholderView.isHidden = true
        snapshotView.frame = CGRect.zero
    }
}

extension TaskListView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return completedTasks.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return activeTasks.count
        }
        else {
            return completedTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as! TaskTableViewCell
        cell.restoreFrame(animated: false)
        var task: TaskViewModel
        if indexPath.section == 0 {
            task = activeTasks[indexPath.row]
        }
        else {
            task = completedTasks[indexPath.row]
        }
        cell.taskView.buttonPressed = { [unowned self] in
            self.animateCompletion(at: indexPath) {
                toggleTaskCompletion?(task.id)
            }
        }
        cell.deletePressed = { [unowned self] in
            var task: TaskViewModel
            if indexPath.section == 0 {
                task = activeTasks[indexPath.row]
            }
            else {
                task = completedTasks[indexPath.row]
            }
            deleteTask?(task.id)
        }
        cell.taskView.update(title: task.title, isDone: task.isDone, color: task.color)
        cell.showsReorderControl = false
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if !activeTasks.isEmpty {
                return Strings.active
            }
            else {
                return "No active tasks " + Strings.glasses
            }
        }
        else {
            return Strings.completed
        }
        
    }
}

extension TaskListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        guard !cell.isEditMode else { return }
        var task: TaskViewModel
        if indexPath.section == 0 {
            task = activeTasks[indexPath.row]
        }
        else {
            task = completedTasks[indexPath.row]
        }
        didSelectTask?(task.id)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension UIGestureRecognizer {
    func cancel() {
        isEnabled = false
        isEnabled = true
    }
}

protocol SwapDelegate {
    func beginSwapping()
    func swap(firstID: Int, secondID: Int)
    func endSwapping()
}
