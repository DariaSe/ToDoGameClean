//
//  CalendarCollectionView.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 13.03.2022.
//

import UIKit

class CalendarCollectionView: UIView {
    
    var isCalendarShown: Bool = false {
        didSet {
            toggleConstraints()
        }
    }
    
    var dataSource: [CalendarDay] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var didSelectDate: ((Date) -> ())?
    
    
    private let weekdaySymbolsView = WeekdaySymbolsView()
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
    private let collectionViewLayout = UICollectionViewFlowLayout()
    
    private var weekdaySymbolsHeightConstraint = NSLayoutConstraint()
    private var interSpacingConstraint = NSLayoutConstraint()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        self.pinToEdges(subview: weekdaySymbolsView, bottom: nil)
        self.pinToEdges(subview: collectionView, top: nil)
        interSpacingConstraint = weekdaySymbolsView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0)
        interSpacingConstraint.isActive = true
        weekdaySymbolsHeightConstraint = weekdaySymbolsView.heightAnchor.constraint(equalToConstant: 0)
        weekdaySymbolsHeightConstraint.isActive = true
        collectionView.backgroundColor = .clear
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func toggleConstraints() {
        interSpacingConstraint.constant = isCalendarShown ? -4 : 0
        weekdaySymbolsHeightConstraint.constant = isCalendarShown ? 12 : 0
    }

}

extension CalendarCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier, for: indexPath) as! CalendarCollectionViewCell
        let day = dataSource[indexPath.row]
        cell.update(with: day)
        return cell
    }
}

extension CalendarCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}

extension CalendarCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = dataSource[indexPath.row]
        return item.belongsToMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = dataSource[indexPath.row]
        didSelectDate?(day.date)
    }
}
