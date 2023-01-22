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
    let title, description: String
    let cookingTime: Int?
    let totalServings: Int?
    var dishWeight: Double?
    let dishWeightType: Int?
    let countries: [String]
    let instructions: [String]?
    let ingredients: [Ingredient]
    let values: Values?
    let eatingTags, dishTypeTags, processingTypeTags, additionalTags: [AdditionalTag]
    let dietTags, exceptionTags: [AdditionalTag]
    let photo: String
    let isDraft: Bool
    let createdAt: String
    
    //    let id: Int
    //    let title: String
    //    let info: String?
    //    let cookTime, kсal: Int
    //    let protein, fat, carbs: Double
    //    let photo: URL?
    //    var rawWeight: Double?
    //    let servings: Int?
    //    let videoURL: URL?
    //    let updatedAt: String
    //    let ingredients: [Ingredient]
    //    let methods: [Method]
    //    let tags: [Tag]
    //    let photos: [Photo]?
    
    var kcal: Double {
        guard let values = values else { return .zero }
        return values.dish.kcal
    }
    
    var carbs: Double {
        guard let values = values else { return .zero }
        return values.dish.carbohydrates
    }
    
    var fat: Double {
        guard let values = values else { return .zero }
        return values.dish.fats
    }
    
    var protein: Double {
        guard let values = values else { return .zero }
        return values.dish.proteins
    }
    
    var info: String? {
        description
    }
    
    var cookTime: Int {
        cookingTime ?? 0
    }
    /// For use in layout
    //    var weight: Double {
    //        return values.
    // Set не нужен вроде
    //        set {
    //            guard let newValue = newValue else { return }
    //            dishWeight = UDM.weightIsMetric ? newValue : newValue / ImperialConstants.lbsToGramsRatio
    //        }
    //    }
    
    //    enum CodingKeys: String, CodingKey {
    //        case id, title, info
    //        case cookTime = "cook_time"
    //        case kсal, protein, fat, carbs, photo, servings
    //        case videoURL = "video_url"
    //        case updatedAt = "updated_at"
    //        case methods, tags, photos, ingredients
    //        case rawWeight = "weight"
    //    }
    
    init?(from managedModel: DomainDish) {
        self.id = Int(managedModel.id)
        self.title = managedModel.title
        self.description = managedModel.info ?? ""
        self.cookingTime = Int(managedModel.cookTime)
        self.totalServings = Int(managedModel.servings)
        self.photo = managedModel.photo?.absoluteString ?? ""
        self.dishWeight = managedModel.weight
        self.dishWeightType = Int(managedModel.dishWeightType)
        self.createdAt = managedModel.updatedAt
        let decoder = JSONDecoder()
        
        if
            let ingredientsData = managedModel.ingredients,
            let ingredients = try? decoder.decode([Ingredient].self, from: ingredientsData) {
            self.ingredients = ingredients
        } else {
            self.ingredients = []
        }
        
        if
            let dishValuesData = managedModel.dishValues,
            let servingValuesData = managedModel.servingValues,
            let hundredValuesData = managedModel.hundredValues,
            let dishValues = try? decoder.decode(DishValues.self, from: dishValuesData),
            let servingValues = try? decoder.decode(DishValues.self, from: servingValuesData),
            let hundredValues = try? decoder.decode(DishValues.self, from: hundredValuesData) {
            self.values = Values(
                dish: dishValues,
                serving: servingValues,
                hundred: hundredValues
            )
        } else {
            self.values = nil
        }
        
        if
            let countriesData = managedModel.countries,
            let countries = try? decoder.decode([String].self, from: countriesData) {
            self.countries = countries
        } else {
            self.countries = []
        }
        
        if let instructionsData = managedModel.methods,
           let instructions = try? decoder.decode([String].self, from: instructionsData) {
            self.instructions = instructions
        } else {
            self.instructions = []
        }
        
        if
            let eatingsTagsData = managedModel.eatingTags,
            let eatingTags = try? decoder.decode([AdditionalTag].self, from: eatingsTagsData) {
            self.eatingTags = eatingTags
        } else {
            self.eatingTags = []
        }
        
        if
            let dishTypeTagsData = managedModel.dishTypeTags,
            let dishTypeTags = try? decoder.decode([AdditionalTag].self, from: dishTypeTagsData) {
            self.dishTypeTags = dishTypeTags
        } else {
            self.dishTypeTags = []
        }
        
        if
            let processingTypeTagsData = managedModel.processingTypeTags,
            let processingTypeTags = try? decoder.decode([AdditionalTag].self, from: processingTypeTagsData) {
            self.processingTypeTags = processingTypeTags
        } else {
            self.processingTypeTags = []
        }
        
        if
            let additionalTagsData = managedModel.additionalTags,
            let additionalTags = try? decoder.decode([AdditionalTag].self, from: additionalTagsData) {
            self.additionalTags = additionalTags
        } else {
            self.additionalTags = []
        }
        
        if
            let dietTagsData = managedModel.dietTags,
            let dietTags = try? decoder.decode([AdditionalTag].self, from: dietTagsData) {
            self.dietTags = dietTags
        } else {
            self.dietTags = []
        }
        
        if
            let exceptionTagsData = managedModel.exceptionTags,
            let exceptionTags = try? decoder.decode([AdditionalTag].self, from: exceptionTagsData) {
            self.exceptionTags = exceptionTags
        } else {
            self.exceptionTags = []
        }
        self.isDraft = false
    }
}

extension Dish: Equatable {
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        return lhs.id == rhs.id
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

//struct Ingredient: Codable {
//    let product: ProductDTO?
//    let amount: String?
//}

struct Ingredient: Codable {
    let id: Int
    let product: ProductDTO
    let quantity: Double
    let isNamed: Bool
    let unit: MarketUnitClass?
}

// MARK: - New DTO

struct AdditionalTag: Codable {
    enum EatingTime: Int {
        case breakfast = 8
        case dinner = 10
        case lunch = 9
        case snack = 11
    }
    
    let id: Int
    let title: String
    
    var eatingType: EatingTime? {
        EatingTime(rawValue: id)
    }
    
}

struct MarketUnitClass: Codable {
    enum MarketUnitPrepared: Int {
        case kilogram = 17
        case gram = 18
        case litter = 19
        case millilitre = 20
        case piece = 21
        case pack = 22
        case bottle = 23
        case tin = 27
        var defaultQuantityStep: Double {
            switch self {
            case .kilogram:
                return 1
            case .gram:
                return 100
            case .litter:
                return 1
            case .millilitre:
                return 100
            case .piece:
                return 1
            case .pack:
                return 1
            case .bottle:
                return 1
            case .tin:
                return 1
            }
        }
    }
    
    let id: Int
    let title, shortTitle: String
    let isOnlyForMarket: Bool
    var step: MarketUnitPrepared? {
        print("Id for step instance  =  \(id)")
        return MarketUnitPrepared(rawValue: id)
    }
}

struct Values: Codable {
    let dish, serving, hundred: DishValues
}

struct DishValues: Codable {
    let weight: Double?
    let netCarbs, proteins, fats: Double
    let kcal: Double
    let carbohydrates: Double
}
