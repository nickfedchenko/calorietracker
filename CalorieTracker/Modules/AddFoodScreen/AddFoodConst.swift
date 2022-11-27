//
//  AddFoodConst.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.11.2022.
//

import UIKit

// MARK: - Const

extension AddFoodViewController {
    struct Const {
        static let hideKeyboardShadow: Shadow = .init(
            color: R.color.addFood.hideKeyboardShadow() ?? .black,
            opacity: 1,
            offset: CGSize(width: 0, height: 1),
            radius: 0
        )
        
        static let menuModels: [MenuView.MenuCellViewModel] = [
            .init(title: "BREAKFAST", image: R.image.addFood.menu.breakfast()),
            .init(title: "LUNCH", image: R.image.addFood.menu.lunch()),
            .init(title: "DINNER", image: R.image.addFood.menu.dinner()),
            .init(title: "SNACK", image: R.image.addFood.menu.snack())
        ]
        
        static let menuCreateModels: [MenuView.MenuCellViewModel] = [
            .init(title: "Food", image: nil),
            .init(title: "Recipe", image: nil),
            .init(title: "Meal", image: nil)
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
                title: AddFood.myMeals.getTitle(),
                normalColor: R.color.addFood.menu.isNotSelectedText(),
                selectedColor: R.color.addFood.menu.isSelectedText(),
                id: .myMeals
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
