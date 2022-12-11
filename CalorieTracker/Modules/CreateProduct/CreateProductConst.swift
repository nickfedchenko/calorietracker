//
//  CreateProductConst.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import Foundation

extension CreateProductViewController {
    enum ProductFormSegment {
        case kcal
        case fat
        case satFat
        case transFat
        case polyFat
        case monoFat
        case choleterol
        case sodium
        case carb
        case dietaryFiber
        case sugars
        case addSugars
        case sugarAlco
        case protein
        case vitaminD
        case calcium
        case iron
        case potassium
        case vitaminA
        case vitaminC
    }
    
    struct Const {
        static let formModels: [FormModel] = [
            .init(type: ProductFormSegment.kcal, width: .large, value: .required(nil)),
            .init(type: ProductFormSegment.fat, width: .large, value: .required(nil)),
            .init(type: ProductFormSegment.satFat, width: .small, value: .optional),
            .init(type: ProductFormSegment.transFat, width: .small, value: .optional),
            .init(type: ProductFormSegment.polyFat, width: .small, value: .optional),
            .init(type: ProductFormSegment.monoFat, width: .small, value: .optional),
            .init(type: ProductFormSegment.choleterol, width: .large, value: .optional),
            .init(type: ProductFormSegment.sodium, width: .large, value: .optional),
            .init(type: ProductFormSegment.carb, width: .large, value: .required(nil)),
            .init(type: ProductFormSegment.dietaryFiber, width: .small, value: .optional),
            .init(type: ProductFormSegment.sugars, width: .small, value: .optional),
            .init(type: ProductFormSegment.addSugars, width: .small, value: .optional),
            .init(type: ProductFormSegment.sugarAlco, width: .small, value: .optional),
            .init(type: ProductFormSegment.protein, width: .large, value: .required(nil)),
            .init(type: ProductFormSegment.vitaminD, width: .large, value: .optional),
            .init(type: ProductFormSegment.calcium, width: .large, value: .optional),
            .init(type: ProductFormSegment.iron, width: .large, value: .optional),
            .init(type: ProductFormSegment.potassium, width: .large, value: .optional),
            .init(type: ProductFormSegment.vitaminA, width: .large, value: .optional),
            .init(type: ProductFormSegment.vitaminC, width: .large, value: .optional)
        ]
    }
}

extension CreateProductViewController.ProductFormSegment: WithGetTitleProtocol {
    func getTitle(_ lenght: Lenght) -> String {
        switch self {
        case .kcal:
            return "Calories"
        case .fat:
            return "Total Fat"
        case .satFat:
            return "Saturated Fat"
        case .transFat:
            return "Trans Fat"
        case .polyFat:
            return "Polyunsaturated Fat"
        case .monoFat:
            return "Monounsaturated Fat"
        case .choleterol:
            return "Cholesterol"
        case .sodium:
            return "Sodium"
        case .carb:
            return "Total Carbohydrate"
        case .dietaryFiber:
            return "Dietary Fiber"
        case .sugars:
            return "Total Sugars"
        case .addSugars:
            return "Includes Added Sugars"
        case .sugarAlco:
            return "Sugar Alcohols"
        case .protein:
            return "Protein"
        case .vitaminD:
            return "Vitamin D"
        case .calcium:
            return "Calcium"
        case .iron:
            return "Iron"
        case .potassium:
            return "Potassium"
        case .vitaminA:
            return "Vitamin A"
        case .vitaminC:
            return "Vitamin C"
        }
    }
}
