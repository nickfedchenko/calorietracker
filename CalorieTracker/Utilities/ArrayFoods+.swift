//
//  ArrayFoods+.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.11.2022.
//

import Foundation

extension Array where Element == Product {
    var foods: [Food] {
        self.map { .product($0) }
    }
}

extension Array where Element == Dish {
    var foods: [Food] {
        self.map { .dishes($0) }
    }
}

extension Array where Element == Meal {
    var foods: [Food] {
        self.map { .meal($0) }
    }
}

extension Array where Element == Food {
    var products: [Product] {
        self.compactMap { food in
            switch food {
            case .product(let product):
                return product
            default:
                return nil
            }
        }
    }
    
    var dishes: [Dish] {
        self.compactMap { food in
            switch food {
            case .dishes(let dish):
                return dish
            default:
                return nil
            }
        }
    }
}
