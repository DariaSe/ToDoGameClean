//
//  CalendarCollectionViewCell.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 13.03.2022.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CalendarCell"
    
    private let label = UILabel()
    private let selectedCircle = UIView()
    private let todayCircle = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        contentView.pinToEdges(subview: selectedCircle)
        contentView.pinToEdges(subview: todayCircle)
        contentView.center(subview: label)
        selectedCircle.layer.cornerRadius = 20
        selectedCircle.layer.backgroundColor = UIColor.AppColors.green.cgColor
        todayCircle.layer.cornerRadius = 20
        todayCircle.layer.borderWidth = 2.0
        todayCircle.layer.borderColor = UIColor.AppColors.green.cgColor
        label.font = UIFont(name: nunitoSemiBold, size: 16)
    }
    
    func update(with calendarDay: CalendarDay) {
        todayCircle.isHidden = !(calendarDay.date ==^ Date())
        let number = Calendar.current.component(.day, from: calendarDay.date)
        label.text = String(number)
        selectedCircle.isHidden = !calendarDay.isSelected
        if calendarDay.isSelected {
            label.isHidden = false
            label.textColor = UIColor.white
            return
        }
        if calendarDay.belongsToMonth {
            label.isHidden = false
            label.textColor = UIColor.textColor
        }
        else {
            label.isHidden = true
            todayCircle.isHidden = true
        }
    }
}
