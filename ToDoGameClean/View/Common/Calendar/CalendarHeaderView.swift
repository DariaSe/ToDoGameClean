//
//  CalendarHeaderView.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 13.03.2022.
//

import UIKit

final class CalendarHeaderView: UIView {
    
    var title: String = "" {
        didSet {
            titleButton.setTitle(title, for: .normal)
        }
    }
    
    var delegate: CalendarInteractorLogic?
    
    private let leftButton = UIButton()
    private let titleButton = UIButton()
    private let rightButton = UIButton()
    
    private let arrowLeft = UIImage(named: "Arrow left")?.withRenderingMode(.alwaysTemplate)
    private let arrowRight = UIImage(named: "Arrow right")?.withRenderingMode(.alwaysTemplate)

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        self.pinToLayoutMargins(subview: leftButton, trailing: nil, top: nil, bottom: nil)
        leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.pinToLayoutMargins(subview: rightButton, leading: nil, top: nil, bottom: nil)
        rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.center(subview: titleButton)
        leftButton.setDimensions(width: 40, height: 40)
        rightButton.setDimensions(width: 40, height: 40)
        
        leftButton.setImage(arrowLeft, for: .normal)
        leftButton.tintColor = UIColor.buttonColor
        leftButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        rightButton.setImage(arrowRight, for: .normal)
        rightButton.tintColor = UIColor.buttonColor
        rightButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        titleButton.titleLabel?.font = UIFont.buttonFont
        titleButton.titleLabel?.textAlignment = .center
        titleButton.setTitleColor(UIColor.buttonColor, for: .normal)
        titleButton.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func buttonPressed(sender: UIButton) {
        sender.animateScale(duration: 0.1, scale: 1.1)
        switch sender {
        case leftButton: delegate?.setPrevious()
        case rightButton: delegate?.setNext()
        case titleButton: delegate?.showHideCalendar()
        default: break
        }
    }
}
