//
//  DailyFoodIntakeCircles.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 17.11.2022.
//

import UIKit

enum DailyFoodIntakeCircles {
    case fat
    case protein
    case carb
    case kcal
    
    struct Colors {
        let background: UIColor?
        let firstCircle: UIColor?
        let secondCircle: UIColor?
    }
    
    func getColors() -> Colors {
        switch self {
        case .fat:
            return .init(
                background: R.color.foodViewing.basicPrimary()?.withAlphaComponent(0.4),
                firstCircle: R.color.foodViewing.fatFirst(),
                secondCircle: R.color.foodViewing.fatSecond()
            )
        case .protein:
            return .init(
                background: R.color.foodViewing.basicPrimary()?.withAlphaComponent(0.4),
                firstCircle: R.color.foodViewing.proteinFirst(),
                secondCircle: R.color.foodViewing.proteinSecond()
            )
        case .carb:
            return .init(
                background: R.color.foodViewing.basicPrimary()?.withAlphaComponent(0.4),
                firstCircle: R.color.foodViewing.carbFirst(),
                secondCircle: R.color.foodViewing.carbSecond()
            )
        case .kcal:
            return .init(
                background: R.color.foodViewing.basicPrimary()?.withAlphaComponent(0.4),
                firstCircle: R.color.foodViewing.kcalFirst(),
                secondCircle: R.color.foodViewing.kcalSecond()
            )
        }
    }
}