//
//  TaskListTableViewCell.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ToDoListCell"
    
    var isEditMode: Bool = false
    
    let containerView = UIView()
    
    let taskView = TaskCellContentView()
    private let deleteView = UIView()
    private let deleteButton = UIButton()
    
    let placeholderView = UIView()
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var showFullWidth: Bool = false
    private var buttonWidth: CGFloat = 80
    private var distance: CGFloat = 0
    
    var deletePressed: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        contentView.backgroundColor = UIColor.clear
        contentView.pinToEdges(subview: placeholderView, leading: 10, trailing: 10, top: 5, bottom: 5)
        placeholderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        placeholderView.layer.cornerRadius = 16
        placeholderView.isHidden = true
        
        contentView.pinToEdges(subview: containerView)
        containerView.pinToEdges(subview: deleteView, leading: nil, trailing: nil, top: 5, bottom: 5)
        deleteView.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -140).isActive = true
        deleteView.setDimensions(width: 130)
        deleteView.pinToEdges(subview: deleteButton)
        deleteView.backgroundColor = UIColor.destructiveColor
        deleteView.layer.cornerRadius = 16
        deleteButton.layer.cornerRadius = 16
        deleteButton.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
        deleteButton.setImage(UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        deleteButton.tintColor = UIColor.backgroundColor
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 70, bottom: 20, right: 26)
        
        containerView.pinToEdges(subview: taskView)
        taskView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.addTarget(self, action: #selector(dragged(sender:)))
        panGestureRecognizer.delegate = self
    }
    
    func update(title: String, isDone: Bool, color: Int?) {
        taskView.update(title: title, isDone: isDone, color: color)
    }
    
    @objc private func delete(sender: UIButton) {
        sender.animateScale(duration: 0.1, scale: 1.1)
        deletePressed?()
    }
    
    @objc private func dragged(sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let translation = sender.translation(in: self.contentView)
            guard abs(translation.x) > abs(translation.y) else { return }
            if taskView.center.x + translation.x < contentView.center.x && distance <= buttonWidth {
                taskView.center = CGPoint(x: taskView.center.x + translation.x, y: taskView.center.y)
                taskView.checkButton.isEnabled = false
                isEditMode = true
            }
            let positionAdjustment = abs(self.contentView.center.x - taskView.center.x)
            distance = positionAdjustment
            sender.setTranslation(CGPoint.zero, in: self.contentView)
            showFullWidth = positionAdjustment > (buttonWidth / 2)
        }
        if sender.state == .ended {
            if showFullWidth {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseOut], animations: {
                    self.taskView.frame = CGRect(x: -self.buttonWidth, y: 0, width: self.taskView.frame.width, height: self.taskView.frame.height)
                }, completion: nil)
            }
            else {
                restoreFrame(animated: true)
            }
        }
    }
    
    func restoreFrame(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut], animations: {
                self.taskView.frame = CGRect(x: 0, y: 0, width: self.taskView.frame.width, height: self.taskView.frame.height)
            }, completion: nil)
        }
        else {
            self.taskView.frame = CGRect(x: 0, y: 0, width: self.taskView.frame.width, height: self.taskView.frame.height)
        }
        taskView.checkButton.isEnabled = true
        isEditMode = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let view = UIView()
        view.frame = contentView.bounds
        view.backgroundColor = .clear
        selectedBackgroundView = view
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
