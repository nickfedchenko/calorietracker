//
//  WidgetType.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.09.2022.
//

import UIKit

enum WidgetType: Codable, CaseIterable {
    case weight
    case calories
    case bmi
    case carb
    case dietary
    case protein
    case steps
    case water
    case exercises
    case active
    
    func getTitle() -> String {
        switch self {
        case .weight:
            return "Weight"
        case .calories:
            return "Calories"
        case .bmi:
            return "BMI"
        case .carb:
            return "Carbohydrates"
        case .dietary:
            return "Dietary Intake"
        case .protein:
            return "Protein"
        case .steps:
            return "Steps"
        case .water:
            return "Water"
        case .exercises:
            return "Exercises"
        case .active:
            return "Active Energy"
        }
    }
    
    func getColor() -> UIColor? {
        switch self {
        case .weight:
            return R.color.progressScreen.weight()
        case .calories:
            return R.color.progressScreen.calories()
        case .bmi:
            return R.color.progressScreen.bmi()
        case .carb:
            return R.color.progressScreen.carb()
        case .dietary:
            return R.color.progressScreen.dietary()
        case .protein:
            return R.color.progressScreen.protein()
        case .steps:
            return R.color.progressScreen.steps()
        case .water:
            return R.color.progressScreen.water()
        case .exercises:
            return R.color.progressScreen.exercises()
        case .active:
            return R.color.progressScreen.active()
        }
    }
}
