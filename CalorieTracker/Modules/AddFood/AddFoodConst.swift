//
//  AddFoodConst.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.11.2022.
//

import UIKit

// MARK: - Const

extension MealTime: WithGetImageProtocol, WithGetTitleProtocol, WithGetDescriptionProtocol {
    func getImage() -> UIImage? {
        switch self {
        case .breakfast:
            return R.image.addFood.menu.breakfast()
        case .launch:
            return R.image.addFood.menu.lunch()
        case .dinner:
            return R.image.addFood.menu.dinner()
        case .snack:
            return R.image.addFood.menu.snack()
        }
    }
    
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .breakfast:
            return R.string.localizable.breakfast().uppercased()
        case .launch:
            return R.string.localizable.lunch().uppercased()
        case .dinner:
            return R.string.localizable.dinner().uppercased()
        case .snack:
            return R.string.localizable.snack().uppercased()
        }
    }
    
    func getDescription() -> NSAttributedString? {
        return nil
    }
}

enum FoodCreate: WithGetTitleProtocol, WithGetImageProtocol, WithGetDescriptionProtocol {
    case food
    case recipe
    case meal
    
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .food:
            return "Food"
        case .recipe:
            return "Recipe"
        case .meal:
            return "Meal"
        }
    }
    
    func getImage() -> UIImage? {
        return nil
    }
    
    func getDescription() -> NSAttributedString? {
        return nil
    }
}

extension AddFoodViewController {
    struct Const {
        static let hideKeyboardShadow: Shadow = .init(
            color: R.color.addFood.hideKeyboardShadow() ?? .black,
            opacity: 1,
            offset: CGSize(width: 0, height: 1),
            radius: 0
        )
        
        static let menuModels: [MealTime] = [
            .breakfast,
            .launch,
            .dinner,
            .snack
        ]
        
        static let menuCreateModels: [FoodCreate] = [
            .food,
            .recipe,
            .meal
        ]
        
        static let menuTypeSecondModels: [FoodInfoCases] = [
            .off,
            .carb,
            .protein,
            .fat
        ]
        
        static let segmentedModels: [SegmentedButton<AddFood>.Model] = [
            .init(
                title: AddFood.frequent.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .frequent
            ),
            .init(
                title: AddFood.recent.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .recent
            ),
            .init(
                title: AddFood.favorites.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .favorites
            ),
            .init(
                title: AddFood.myRecipes.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .myRecipes
            ),
            .init(
                title: AddFood.myFood.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .myFood
            )
        ]
    }
}

enum AddFood {
    case frequent
    case recent
    case favorites
    case myMeals
    case myRecipes
    case myFood
    case search
    
    func getTitle() -> String {
        switch self {
        case .frequent:
            return "Frequent"
        case .recent:
            return "Recent"
        case .favorites:
            return "Favorites"
        case .myMeals:
            return "My Meals"
        case .myRecipes:
            return "My Recipes"
        case .myFood:
            return "My Food"
        default:
            return ""
        }
    }
}
