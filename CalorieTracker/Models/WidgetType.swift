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
            return R.string.localizable.weight()
        case .calories:
            return R.string.localizable.kcal()
        case .bmi:
            return R.string.localizable.bmiShort()
        case .carb:
            return R.string.localizable.carb()
        case .dietary:
            return R.string.localizable.tripleDiagramChartTypeDietaryTitle().capitalized
        case .protein:
            return R.string.localizable.protein()
        case .steps:
            return R.string.localizable.widgetStepsTitle().capitalized
        case .water:
            return R.string.localizable.widgetWaterTitle().capitalized
        case .exercises:
            return R.string.localizable.exercises()
        case .active:
            return R.string.localizable.active()
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
