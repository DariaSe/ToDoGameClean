//
//  RecurrenceRule.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import Foundation

struct RecurrenceRule: Codable {
    
    enum RecurrenceType: Int, RawRepresentable {
        case regular
        case withIntervals
        case onWeekdays
    }
    
    var recurrenceType: RecurrenceType = .regular
    var recurrenceFrequency: RecurrenceFrequency?
    var interval: Int = 0
    var weekdays: [Int] = []
    
    static let zero = RecurrenceRule(recurrenceType: .regular, recurrenceFrequency: .daily, interval: 0, weekdays: [])
    
    
    static let sample1 = RecurrenceRule(recurrenceType: .withIntervals, recurrenceFrequency: .daily, interval: 2, weekdays: [])
    static let sample2 = RecurrenceRule(recurrenceType: .regular, recurrenceFrequency: .weekly, interval: 0, weekdays: [])
    static let sample3 = RecurrenceRule(recurrenceType: .onWeekdays, recurrenceFrequency: nil, interval: 0, weekdays: [2, 5])
    
    init() {}
    
    init(recurrenceType: RecurrenceType, recurrenceFrequency: RecurrenceFrequency?, interval: Int, weekdays: [Int]) {
        self.recurrenceType = recurrenceType
        self.recurrenceFrequency = recurrenceFrequency
        self.interval = interval
        self.weekdays = weekdays
    }
    
    // MARK: - Decoding and encoding
    private enum CodingKeys: String, CodingKey {
        case recurrenceType = "recurrence_type"
        case recurrenceFrequency = "recurrence_frequency"
        case interval
        case weekdays
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let recurrenceTypeInt = try values.decode(Int.self, forKey: .recurrenceType)
        recurrenceType = RecurrenceType(rawValue: recurrenceTypeInt) ?? .regular
        let recurrenceFrequencyInt = try values.decode(Int?.self, forKey: .recurrenceFrequency)
        recurrenceFrequency = RecurrenceFrequency(rawValue: recurrenceFrequencyInt ?? 999)
        interval = try values.decode(Int.self, forKey: .interval)
        weekdays = try values.decode([Int].self, forKey: .weekdays)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recurrenceType.rawValue, forKey: .recurrenceType)
        try container.encode(recurrenceFrequency?.rawValue, forKey: .recurrenceFrequency)
        try container.encode(interval, forKey: .interval)
        try container.encode(weekdays, forKey: .weekdays)
    }
}

enum RecurrenceFrequency: Int, Codable, CaseIterable {
    
    case daily
    case weekly
    case monthly
    case yearly

    var string: String {
        switch self {
        case .daily: return Strings.daily
        case .weekly: return Strings.weekly
        case .monthly: return Strings.monthly
        case .yearly: return Strings.yearly
        }
    }

    func string(_ count: Int ) -> String {
        switch self {
        case .daily: return Strings.daysCount.localizedForCount(count)
        case .weekly: return Strings.weeksCount.localizedForCount(count)
        case .monthly: return Strings.monthsCount.localizedForCount(count)
        case .yearly: return Strings.yearsCount.localizedForCount(count)
        }
    }
}

