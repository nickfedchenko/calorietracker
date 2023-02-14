//
//  Day.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.08.2022.
//

import Foundation

struct Day: Hashable, Comparable, Codable {
    
    let date: Date?
    
    let day: Int
    let month: Int
    let year: Int
    
    init(_ date: Date) {
        let calendar = Calendar.current
        self.date = date
        self.day = calendar.component(.day, from: date)
        self.month = calendar.component(.month, from: date)
        self.year = calendar.component(.year, from: date)
    }
    
    init(day: Int, month: Int, year: Int) {
        let calendar = Calendar.current
        self.day = day
        self.month = month
        self.year = year
        self.date = calendar.date(from: .init(
            calendar: calendar,
            timeZone: .current,
            year: year,
            month: month,
            day: day
        ))
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(year)\(month)\(day)")
    }
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
    
    static func < (lhs: Day, rhs: Day) -> Bool {
        guard let lhsDate = lhs.date, let rhsDate = rhs.date else {
            return false
        }
        return lhsDate < rhsDate
    }
    
    static func - (lhs: Day, rhs: Int) -> Day {
        guard let date = lhs.date else { return lhs }
        return Day(date - Double(rhs * 24 * 60 * 60))
    }
}
