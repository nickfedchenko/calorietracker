//
//  Meal.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.11.2022.
//

import Foundation

struct Meal {
    let id: String
    let title: String
    let mealTime: MealTime
    let products: [Product]
    let dishes: [Dish]
    let customEntries: [CustomEntry]
    let photoURL: String
    
    init?(from managedModel: DomainMeal) {
        self.id = managedModel.id
        self.title = managedModel.title
        self.photoURL = managedModel.photoURL
        self.mealTime = MealTime(rawValue: managedModel.mealTime) ?? .breakfast
        self.products = managedModel.products?
            .compactMap { $0 as? DomainProduct }
            .compactMap { Product(from: $0) } ?? []
        self.dishes = managedModel.dishes?
            .compactMap { $0 as? DomainDish }
            .compactMap { Dish(from: $0) } ?? []
        self.customEntries = managedModel.customEntries?
            .compactMap { $0 as? DomainCustomEntry }
            .compactMap { CustomEntry(from: $0) } ?? []
        
        
        
//        if let photoData = managedModel.photo {
//            self.photo = try? JSONDecoder().decode(Photo.self, from: photoData)
//        } else {
//            self.photo = nil
//        }
    }
    
    struct Photo: Codable {
        var photoData: Data?
    }
    
    init(mealTime: MealTime, title: String, photoURL: String?) {
        self.mealTime = mealTime
        self.title = title
        
        self.photoURL = photoURL ?? ""
        
//        if let photo = photo {
//            self.photo = Photo(photoData: photo)
//        } else {
//            self.photo = nil
//        }
        
        self.products = []
        self.dishes = []
        self.customEntries = []
        self.id = UUID().uuidString
    }
}

enum MealTime: String {
    case breakfast
    case launch
    case dinner
    case snack
}

extension Meal {
    func setChild(dishes: [Dish], products: [Product], customEntries: [CustomEntry]) {
        DSF.shared.setChildMeal(
            mealId: self.id,
            dishesID: dishes.map { $0.id },
            productsID: products.map { $0.id },
            customEntriesID: customEntries.map { $0.id }
        )
    }
}

extension Meal: Equatable {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.id == rhs.id
    }
}
