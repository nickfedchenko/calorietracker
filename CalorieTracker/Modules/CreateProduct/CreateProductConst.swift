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
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .kcal:
            return R.string.localizable.kcal()
        case .fat:
            return R.string.localizable.fat()
        case .satFat:
            return R.string.localizable.satFat()
        case .transFat:
            return R.string.localizable.transFat()
        case .polyFat:
            return R.string.localizable.polyFat()
        case .monoFat:
            return R.string.localizable.monoFat()
        case .choleterol:
            return R.string.localizable.choleterol()
        case .sodium:
            return R.string.localizable.sodium()
        case .carb:
            return R.string.localizable.carb()
        case .dietaryFiber:
            return R.string.localizable.dietaryFiber()
        case .sugars:
            return R.string.localizable.sugars()
        case .addSugars:
            return R.string.localizable.addSugars()
        case .sugarAlco:
            return R.string.localizable.sugarAlco()
        case .protein:
            return R.string.localizable.protein()
        case .vitaminD:
            return R.string.localizable.vitaminD()
        case .calcium:
            return R.string.localizable.calcium()
        case .iron:
            return R.string.localizable.iron()
        case .potassium:
            return R.string.localizable.potassium()
        case .vitaminA:
            return R.string.localizable.vitaminA()
        case .vitaminC:
            return R.string.localizable.vitaminC()
        }
    }
}
