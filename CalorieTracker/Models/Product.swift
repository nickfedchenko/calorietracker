//
//  Product.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 12.12.2022.
//

import UIKit

struct Product {
    let id: Int
    let title: String
    let barcode: String?
    let brand: String?
    let protein, fat, carbs, kcal: Double
    let photo: Photo?
    let composition: Composition?
    let servings: [Serving]?
    
    enum Photo {
        case url(URL)
        case data(Data)
    }
}

struct Composition {
    let vitaminA, vitaminD, vitaminC, calcium,
        sugar, fiber, satFat, unsatFat, transFat,
        sodium, cholesterol, potassium, sugarAlc,
        iron, addSugar: Double?
    
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

struct Serving {
    let title: String?
    let weight: Double?
    
    init(_ serving: ServingDTO) {
        self.title = serving.title
        self.weight = serving.weight
    }
}

extension Product {
    init(_ product: ProductDTO) {
        self.id = product.id
        self.barcode = product.barcode
        self.title = product.title
        self.brand = product.brand
        self.protein = product.protein
        self.fat = product.fat
        self.kcal = Double(product.kcal)
        self.carbs = product.carbs
        
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
