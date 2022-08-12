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
    let title: String
    let info: String?
    let cookTime, kсal: Int
    let protein, fat, carbs: Double
    let photo: URL?
    let weight: Int?
    let servings: Int?
    let videoURL: URL?
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
    
    init?(from managedModel: DomainDish) {
        id = Int(managedModel.id)
        title = managedModel.title
        info = managedModel.info
        cookTime = Int(managedModel.cookTime)
        kсal = Int(managedModel.kcal)
        protein = managedModel.protein
        fat = managedModel.fat
        carbs = managedModel.carbs
        photo = managedModel.photo
        weight = managedModel.weight == -1 ? nil : Int(managedModel.weight)
        servings = managedModel.servings == -1 ? nil : Int(managedModel.servings)
        videoURL = managedModel.videoURL
        updatedAt = managedModel.updatedAt
        if let ingredientsData = managedModel.ingredients,
           let ingredients = try? JSONDecoder().decode([Ingredient].self, from: ingredientsData) {
            self.ingredients = ingredients
        } else {
            self.ingredients = []
        }
        
        if let methodsData = managedModel.methods,
           let methods = try? JSONDecoder().decode([Method].self, from: methodsData) {
            self.methods = methods
        } else {
            self.methods = []
        }
        
        if let tagsData = managedModel.tags,
           let tags = try? JSONDecoder().decode([Tag].self, from: tagsData) {
            self.tags = tags
        } else {
            self.tags = []
        }
        
        if let photosData = managedModel.photos,
           let photos = try? JSONDecoder().decode([Photo].self, from: photosData) {
            self.photos = photos
        } else {
            self.photos = []
        }
    }
}

struct Method: Codable {
    let content: String?
    let timer: Int?
}

struct Photo: Codable {
    let photo: String?
}

struct Tag: Codable {
    let tag: String?
}

struct Ingredient: Codable {
    let product: Product?
    let amount: String?
}
