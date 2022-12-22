//
//  Date+days.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 31.08.2022.
//

import Foundation

extension Date {
    func days(to secondDate: Date, calendar: Calendar = Calendar.current) -> Int? {
        return calendar.dateComponents([.day], from: self, to: secondDate).day
    }
    
    func weeks(to secondDate: Date, calendar: Calendar = Calendar.current) -> Int? {
        return calendar.dateComponents([.weekOfMonth], from: self, to: secondDate).weekOfMonth
    }
    
    func months(to secondDate: Date, calendar: Calendar = Calendar.current) -> Int? {
        return calendar.dateComponents([.month], from: self, to: secondDate).month
    }
    
    func years(to secondDate: Date, calendar: Calendar = Calendar.current) -> Int? {
        return calendar.dateComponents([.year], from: self, to: secondDate).year
    }
}
