//
//  CalendarService.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 13.03.2022.
//

import Foundation

class CalendarService {
    
    static func makeCalendarDays(containing date: Date) -> [CalendarDay] {
        let dates = Calendar.current.extendedMonth(containing: date)
        let calendarDays = dates.map { (arrayDate) -> CalendarDay in
            let belongsToMonth = arrayDate.belongsToMonth(of: date)
            let isSelected = arrayDate.dayStart == date.dayStart
            return CalendarDay(date: arrayDate, belongsToMonth: belongsToMonth, isSelected: isSelected)
        }
        return calendarDays
    }
    
    static func numberOfWeeksInMonth(containing date: Date) -> Int {
        let dates = Calendar.current.extendedMonth(containing: date)
        return Int(ceil(Double(dates.count) / 7.0))
    }
}
