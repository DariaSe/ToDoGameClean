//
//  ErrorView.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 14.03.2022.
//

import UIKit

class ErrorView: UIView {
    
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        self.backgroundColor = .destructiveColor
        self.layer.cornerRadius = 12
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.center(subview: label)
        label.numberOfLines = 4
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.normalTextFont
    }
    
    func setText(_ text: String) {
        label.text = text
    }
}
