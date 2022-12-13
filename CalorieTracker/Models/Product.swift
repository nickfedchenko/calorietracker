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
    let vitaminA, vitaminD, vitaminC, calcium,
        sugar, fiber, satFat, unsatFat, transFat,
        sodium, cholesterol, potassium, sugarAlc,
        iron, addSugar: Double?
}

struct Serving: Codable {
    let title: String?
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
        self.isUserProduct = true
        
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
        
        self.servings = product.servings?.compactMap { .init($0) }
        
        self.composition = {
            guard let compositionDTO = product.composition else { return nil }
            return .init(compositionDTO)
        }()
        
        self.photo = {
            guard let url = product.photo else { return nil }
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
    init(_ composition: CompositionDTO) {
        self.vitaminA = composition.vitaminA
        self.vitaminD = composition.vitaminD
        self.vitaminC = composition.vitaminC
        self.calcium = composition.calcium
        self.sugar = composition.sugar
        self.fiber = composition.fiber
        self.satFat = composition.saturatedFat
        self.unsatFat = composition.unsaturatedFat
        self.transFat = composition.transFat
        self.sodium = composition.sodium
        self.cholesterol = composition.cholesterol
        self.potassium = composition.potassium
        self.sugarAlc = composition.sugarAlc
        self.iron = composition.iron
        self.addSugar = nil
    }
}

extension Serving {
    init(_ serving: ServingDTO) {
        self.title = serving.title
        self.weight = serving.weight
    }
}
