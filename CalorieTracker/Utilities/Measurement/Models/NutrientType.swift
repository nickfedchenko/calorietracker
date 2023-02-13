//
//  NutrientType.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.12.2022.
//

import UIKit

enum NutrientType {
    case fat
    case protein
    case carbs
}

extension NutrientType: WithGetColorProtocol {
    func getColor() -> UIColor? {
        switch self {
        case .fat:
            return R.color.openMainWidget.fat()
        case .protein:
            return R.color.openMainWidget.protein()
        case .carbs:
            return R.color.openMainWidget.carbs()
        }
    }
}
