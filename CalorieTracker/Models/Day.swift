//
//  Day.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.08.2022.
//

import Foundation

struct Day: Hashable {
    private let date: Date
    
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(year)\(month)\(day)")
    }
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
    
    static func - (lhs: Day, rhs: Int) -> Day {
        return Day(lhs.date - Double(rhs * 24 * 60 * 60))
    }
}
