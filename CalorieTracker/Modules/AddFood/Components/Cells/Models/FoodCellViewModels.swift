//
//  FoodCellViewModels.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.01.2023.
//

import UIKit

struct FoodCellViewModel {
    let cellType: CellType
    let food: Food?
    let buttonType: CellButtonType
    let subInfo: Int?
    let colorSubInfo: UIColor?
    let isFromSelectedFoodController: Bool
}

enum CellType {
    case table
    case withShadow
}

enum CellButtonType {
    case delete
    case add
    case addToMeal
}
