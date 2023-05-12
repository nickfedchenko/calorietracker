//
//  Date+resetDate.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.09.2022.
//

import Foundation

extension Date {
    var resetDate: Date? {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }
    
    var endOfDay: Date? {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)
    }
}
