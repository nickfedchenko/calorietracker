//
//  Dish.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 10.08.2022.
//

import UIKit

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
    let dietTags: [AdditionalTag]
    let exceptionTags: [ExceptionTag]
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
    
    // swiftlint:disable:next function_body_length
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
            let exceptionTags = try? decoder.decode([ExceptionTag].self, from: exceptionTagsData) {
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

// struct Ingredient: Codable {
//    let product: ProductDTO?
//    let amount: String?
// }

struct Ingredient: Codable {
    let id: Int
    let product: ProductDTO
    let quantity: Double
    let isNamed: Bool
    let unit: MarketUnitClass?
}

// MARK: - New DTO

struct AdditionalTag: Hashable, Codable {
    enum ConvenientTag: Int, Codable {
        case breakfast = 8
        case dinner = 10
        case lunch = 9
        case snack = 11
        case garnish = 12
        case salad = 13
        case soup = 14
        case drink = 15
        case bakery = 16
        case sandwich = 17
        case pizza = 18
        case appetiser = 19
        case sauce = 42
        case withoutHeat = 20
        case toBoil = 21
        case toBake = 22
        case toSteam = 23
        case toFry = 24
        case toStew = 25
        case microwaving = 26
        case onCoals = 27
        case deepFried = 41
        case suvid = 43
        case juniorMenu = 28
        case intalianCusine = 29
        case asianCusine = 30
        case chrismasAndNewYear = 31
        case lowCarb = 32
        case highProtein = 33
        case lowFat = 34
        case keto = 35
        case paleo = 36
        case mediterranean = 37
        case pescatarian = 38
        case vegetarian = 39
        case vegan = 40
        case favorite = 9999
    }
    
    let id: Int
    let title: String
    
    var convenientTag: ConvenientTag? {
        ConvenientTag(rawValue: id)
    }
    
    var tagColorRepresentation: TagTypeColorRepresentation? {
        guard let convenientTag = convenientTag else { return nil }
        switch convenientTag {
        case .salad, .soup, .drink, .bakery, .sandwich, .pizza, .appetiser, .sauce, .garnish:
            return .dish
        case .toBoil, .toBake, .toSteam, .toStew, .toFry, .microwaving, .onCoals, .deepFried, .withoutHeat, .suvid:
            return .method
        case .breakfast, .lunch, .dinner, .snack:
            return .meal
        case .juniorMenu, .intalianCusine, .asianCusine, .chrismasAndNewYear, .lowFat, .lowCarb, .highProtein,
                .keto, .paleo, .mediterranean, .pescatarian, .vegetarian, .vegan:
            return .diet
        case .favorite:
            return .favorites
        }
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

enum TagTypeColorRepresentation {
    case favorites
    case meal
    case dish
    case diet
    case method
    case ingredients
    case custom
    
    var baseColor: UIColor? {
        switch self {
        case .favorites:
            return UIColor(hex: "FFB3A8")
        case .meal:
            return UIColor(hex: "FFC37D")
        case .dish:
            return UIColor(hex: "FFE665")
        case .diet:
            return UIColor(hex: "ADE7A4")
        case .method:
            return UIColor(hex: "B7EFF6")
        case .ingredients:
            return UIColor(hex: "ADCCFA")
        case .custom:
            return UIColor(hex: "DAC2FA")
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .favorites:
            return UIColor(hex: "DE422B")
        case .meal:
            return UIColor(hex: "D77707")
        case .dish:
            return UIColor(hex: "DDB900")
        case .diet:
            return UIColor(hex: "51AF43")
        case .method:
            return UIColor(hex: "3BC6D8")
        case .ingredients:
            return UIColor(hex: "4681D9")
        case .custom:
            return UIColor(hex: "9560DC")
        }
    }
}
