//
//  Array+Difference.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 15.09.2022.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
