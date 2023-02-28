//
//  NSMergePolicy+CustomPolicies.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 28.02.2023.
//

import CoreData

extension NSMergePolicy {
    static let safeMergePolicy: SafeMergePolicy = SafeMergePolicy()
}
