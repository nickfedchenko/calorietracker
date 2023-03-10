//
//  SafeMergePolicy.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 28.02.2023.
//

import CoreData

class SafeMergePolicy: NSMergePolicy {
    
    init() {
        super.init(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    }
    
//    override func resolve(optimisticLockingConflicts list: [NSMergeConflict]) throws {
//        print(list)
//        for conflict in list {
//            let sourceObject = conflict.sourceObject
//            guard let persistentSnapshot = conflict.persistedSnapshot else {
//                return
//            }
//            if let sourceObject = sourceObject as? DomainDish {
//                let storedFoodData = persistentSnapshot["foodData"] as? DomainFoodData
//                sourceObject.foodData = storedFoodData
//                try super.resolve(optimisticLockingConflicts: list)
//                continue
//            }
//        }
//    }
    
    override func resolve(constraintConflicts list: [NSConstraintConflict]) throws {
        for conflict in list {
            guard let databaseObject = conflict.databaseObject else {
                try super.resolve(constraintConflicts: list)
                return
            }
            let allKeys = databaseObject.entity.relationshipsByName.keys
            for conflictObject in conflict.conflictingObjects {
                let changedKeys = conflictObject.changedValues().keys
                let keys = allKeys.filter { !changedKeys.contains($0) }
                for key in keys {
//                    if key == "foodData" {
                        let value = databaseObject.value(forKey: key)
                        conflictObject.setValue(value, forKey: key)
                        databaseObject.setValue(nil, forKey: key)
//                    }
                }
            }
        }
        try super.resolve(constraintConflicts: list)
    }
}
