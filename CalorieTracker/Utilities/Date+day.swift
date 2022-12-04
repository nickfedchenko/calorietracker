//
//  Date+day.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 04.12.2022.
//

import Foundation

extension Date {
    var day: Day { Day(self) }
}
