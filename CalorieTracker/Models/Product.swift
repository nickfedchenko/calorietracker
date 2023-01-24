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
    let photo: Photo?
    let composition: Composition?
    let servings: [Serving]?
    
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
        self.id = managedModel.id
        self.barcode = managedModel.barcode
        self.title = managedModel.title
        self.brand = managedModel.brand
        self.protein = managedModel.protein
        self.fat = managedModel.fat
        self.kcal = managedModel.kcal
        self.carbs = managedModel.carbs
        self.isUserProduct = managedModel.isUserProduct
        
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
       
        self.composition = Composition(product.nutritions)
        
        self.photo = {
            guard let url = URL(string: product.photo) else { return nil }
            return .url(url)
        }()
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
                continue
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
