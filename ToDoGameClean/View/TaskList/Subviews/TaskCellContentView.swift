//
//  TaskCellContentView.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import UIKit

final class TaskCellContentView: UIView {
    
    var buttonPressed: (() -> Void)?
  
    private let roundedView = UIView()
    
    private let colorView = UIView()
    private let label = UILabel()
    let checkButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        setupLayout()
        self.backgroundColor = UIColor.clear
        roundedView.layer.cornerRadius = 16
        roundedView.clipsToBounds = true
        roundedView.backgroundColor = UIColor.white
       
        checkButton.addTarget(self, action: #selector(checkButtonPressed), for: .touchUpInside)
    }
 
    func setupLayout() {
        self.pinToEdges(subview: roundedView, leading: 10, trailing: 10, top: 5, bottom: 5)
        roundedView.pinToEdges(subview: colorView, trailing: nil)
        
        colorView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        roundedView.pinToEdges(subview: label, leading: 30, trailing: 70, top: 24, bottom: 24)
        
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        roundedView.addSubview(checkButton)
        checkButton.centerYAnchor.constraint(equalTo: roundedView.centerYAnchor).isActive = true
        checkButton.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor, constant: -14).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        checkButton.widthAnchor.constraint(equalTo: checkButton.heightAnchor).isActive = true
    }
    
    func update(title: String, isDone: Bool, color: Int?) {
        if isDone {
            let titleString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.strikethroughStyle : 1])
            label.attributedText = titleString
            label.layer.opacity = 0.8
        }
        else {
            label.attributedText = NSAttributedString(string: title)
            label.layer.opacity = 1.0
            checkButton.tintColor = UIColor.AppColors.darkGreen
        }
        label.textColor = UIColor.textColor
        label.font = UIFont.normalTextFont
        
        if let color = color {
            colorView.backgroundColor = UIColor.tagColor(index: color)
            checkButton.tintColor = UIColor.tagColor(index: color)
        }
        else {
            colorView.backgroundColor = UIColor.noColorColor
            checkButton.tintColor = UIColor.noColorColor
        }

        let buttonImageName = isDone ? "Round - on" : "Round - off"
        let buttonImage = UIImage(named: buttonImageName)?.withRenderingMode(.alwaysTemplate)
        checkButton.setImage(buttonImage, for: .normal)
        checkButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    }
    
    
    @objc func checkButtonPressed() {
        buttonPressed?()
    }
    
}

