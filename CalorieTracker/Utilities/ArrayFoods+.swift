//
//  ArrayFoods+.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.11.2022.
//

import Foundation

extension Array where Element == Product {
    var foods: [Food] {
        self.map { .product($0, customAmount: nil, unit: nil) }
    }
}

extension Array where Element == Dish {
    var foods: [Food] {
        self.map { .dishes($0, customAmount: nil) }
    }
}

extension Array where Element == Meal {
    var foods: [Food] {
        self.map { .meal($0) }
    }
}

extension Array where Element == CustomEntry {
    var foods: [Food] {
        self.map { .customEntry($0) }
    }
}

extension Array where Element == Food {
    var products: [Product] {
        self.compactMap { food in
            switch food {
            case .product(let product, _, _):
                return product
            default:
                return nil
            }
        }
    }
    
    var dishes: [Dish] {
        self.compactMap { food in
            switch food {
            case .dishes(let dish, _):
                return dish
            default:
                return nil
            }
        }
    }
    
    var customEntries: [CustomEntry] {
        self.compactMap { food in
            switch food {
            case .customEntry(let entry):
                return entry
            default:
                return nil
            }
        }
    }
}
