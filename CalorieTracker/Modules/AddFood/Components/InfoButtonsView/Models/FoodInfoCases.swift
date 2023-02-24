//
//  FoodInfoCases.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 08.11.2022.
//

import UIKit

protocol WithGetDataProtocol: WithGetTitleProtocol, WithGetColorProtocol {}

enum FoodInfoCases: WithGetDataProtocol {
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .carb:
            return lenght == .long
            ? R.string.localizable.carbsLong()
            : R.string.localizable.carbsShort()
        case .fat:
            return lenght == .long
            ? R.string.localizable.fatLong()
            : R.string.localizable.fatShort()
        case .kcal:
            return lenght == .long
            ? R.string.localizable.kcalShort()
            : R.string.localizable.kcalShort()
        case .off:
            return lenght == .long
            ? R.string.localizable.off()
            : R.string.localizable.off()
        case .protein:
            return lenght == .long
            ? R.string.localizable.proteinLong()
            : R.string.localizable.proteinShort()
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
