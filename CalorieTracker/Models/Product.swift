//
//  Product.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 12.12.2022.
//

import UIKit

struct Product {
    let id: String
    let title: String
    let isUserProduct: Bool
    let barcode: String?
    let brand: String?
    let protein, fat, carbs, kcal: Double
    let productURL: Int?
    let photo: Photo?
    let composition: Composition?
    let servings: [Serving]?
    var units: [UnitElement]?
    let ketoRating: String?
    let baseTags: [ExceptionTag]
    let createdAt: String
    
    var foodDataId: String?
    
    enum Photo: Codable {
        case url(URL)
        case data(Data)
    }
}

struct Composition: Codable {
    var vitaminA, vitaminD, vitaminC, calcium,
        sugar, fiber, satFat, unsatFat, transFat,
        sodium, cholesterol, potassium, sugarAlc,
        iron, addSugar: Double?
}

struct Serving: Codable {
    let size: String?
    let weight: Double?
}

extension Product {
    init?(from managedModel: DomainProduct) {
        self.id = String(managedModel.id)
        self.barcode = managedModel.barcode
        self.title = managedModel.title
        self.brand = managedModel.brand
        self.protein = managedModel.protein
        self.fat = managedModel.fat
        self.kcal = managedModel.kcal
        self.carbs = managedModel.carbs
        self.isUserProduct = managedModel.isUserProduct
        self.productURL = Int(managedModel.productURL)
        self.foodDataId = managedModel.foodData?.id
        self.createdAt = managedModel.createdAt ?? ""
        if let photoData = managedModel.photo {
            self.photo = try? JSONDecoder().decode(Photo.self, from: photoData)
        } else {
            self.photo = nil
        }
        
        if let servingsData = managedModel.servings {
            self.servings = try? JSONDecoder().decode([Serving].self, from: servingsData)
        } else {
            self.servings = nil
        }
        
        if let compositionData = managedModel.servings {
            self.composition = try? JSONDecoder().decode(Composition.self, from: compositionData)
        } else {
            self.composition = nil
        }
        
        if let unitsData = managedModel.units {
            self.units = try? JSONDecoder().decode([UnitElement].self, from: unitsData)
        } else {
            self.units = nil
        }
        let secondsPassed = Date().timeIntervalSince1970
        self.ketoRating = managedModel.ketoRating
        if let domainBaseTags = managedModel.exceptionTags?.array as? [DomainExceptionTag] {
            self.baseTags = domainBaseTags.compactMap { ExceptionTag(from: $0) }
        } else {
            self.baseTags = []
        }
    }
    
    init(_ product: ProductDTO) {
        self.id = String(product.id)
        self.barcode = product.barcode
        self.title = product.title
        self.brand = product.brand
        self.protein = product.protein
        self.fat = product.fat
        self.kcal = Double(product.kcal)
        self.carbs = product.carbs
        self.isUserProduct = false
        self.servings = [product.serving]
        self.units = product.units
        self.productURL = product.productURL
        self.composition = Composition(product.nutritions)
        self.createdAt = product.createdAt
        self.photo = {
            guard let url = URL(string: product.photo) else { return nil }
            return .url(url)
        }()
        self.ketoRating = product.ketoRating
        self.baseTags = product.baseTags
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Composition {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    init(_ nutritions: [Nutrition]) {
        for nutrition in nutritions {
            switch nutrition.nutritionType {
            
            case .fatsOverall:
                continue
            case .saturatedFats:
                self.satFat = nutrition.value ?? .zero
            case .transFats:
                self.transFat = nutrition.value ?? .zero
            case .polyUnsaturatedFats:
                self.unsatFat = nutrition.value ?? .zero
            case .monoUnsaturatedFats:
                continue
            case .cholesterol:
                self.cholesterol = nutrition.value ?? .zero
            case .sodium:
                self.sodium = nutrition.value ?? .zero
            case .carbsTotal:
                continue
            case .alimentaryFiber:
                self.fiber = nutrition.value ?? .zero
            case .netCarbs:
                continue
            case .sugarOverall:
                self.sugar = nutrition.value ?? .zero
            case .includingAdditionalSugars:
                self.addSugar = nutrition.value ?? .zero
            case .sugarSpirits:
                self.sugarAlc = nutrition.value ?? .zero
            case .protein:
                continue
            case .vitaminD:
                self.vitaminD = nutrition.value ?? .zero
            case .calcium:
                self.calcium = nutrition.value ?? .zero
            case .ferrum:
                self.iron = nutrition.value ?? .zero
            case .potassium:
                self.potassium = nutrition.value ?? .zero
            case .vitaminA:
                self.vitaminA = nutrition.value ?? .zero
            case .vitaminC:
                self.vitaminC = nutrition.value ?? .zero
            case .kcal:
                continue
            case .undefined:
                continue
            }
        }
    }
}
