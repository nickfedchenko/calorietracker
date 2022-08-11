//
//  Dish.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 10.08.2022.
//

import Foundation
typealias DishesResponse = (Result<[Dish], ErrorDomain>) -> Void

struct Dish: Codable {
    let id: Int
    let title, info: String?
    let cookTime, kсal: Int
    let protein, fat, carbs: Double
    let photo: String
    let weight: Int?
    let servings: Int
    let videoURL: String?
    let updatedAt: String
    let ingredients: [Ingredient]
    let methods: [Method]
    let tags: [Tag]
    let photos: [Photo]?

    enum CodingKeys: String, CodingKey {
        case id, title, info
        case cookTime = "cook_time"
        case kсal, protein, fat, carbs, photo, weight, servings
        case videoURL = "video_url"
        case updatedAt = "updated_at"
        case methods, tags, photos, ingredients
    }
}

struct Method: Codable {
    let content: String?
    let timer: Int?
}

struct Photo: Codable {
    let photo: String
}

struct Tag: Codable {
    let tag: String
}

struct Ingredient: Codable {
    let product: Product
    let amount: String
}
