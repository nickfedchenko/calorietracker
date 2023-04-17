//
//  Decimal+doubleValue.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 13.04.2023.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
