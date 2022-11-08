//
//  FoodInfoCases.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 08.11.2022.
//

import UIKit

protocol WithGetDataProtocol: WithGetTitleProtocol, WithGetColorProtocol {}

enum FoodInfoCases: WithGetDataProtocol {
    func getTitle(_ lenght: Lenght) -> String {
        switch self {
        case .carb:
            return lenght == .long
                ? "Carbohydrates"
                : "Carb"
        case .fat:
            return lenght == .long
                ? "Fat"
                : "Fat"
        case .kcal:
            return lenght == .long
                ? "Kcal"
                : "Kcal"
        case .off:
            return lenght == .long
                ? "Off"
                : "Off"
        case .protein:
            return lenght == .long
                ? "Protein"
                : "Prot"
        }
    }
    
    func getColor() -> UIColor? {
        switch self {
        case .carb:
            return R.color.addFood.menu.carb()
        case .fat:
            return R.color.addFood.menu.fat()
        case .kcal:
            return R.color.addFood.menu.kcal()
        case .off:
            return R.color.addFood.menu.off()
        case .protein:
            return R.color.addFood.menu.protein()
        }
    }
    
    case carb
    case fat
    case kcal
    case off
    case protein
}
