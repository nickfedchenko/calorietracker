//
//  SelectedFoodCellsRouter.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.11.2022.
//

import UIKit

protocol SelectedFoodCellsRouterInterface: AnyObject {
    func close()
    func openProductViewController(_ product: Product)
    func openDishViewController(_ dish: Dish)
}

class SelectedFoodCellsRouter: NSObject {
    weak var viewController: SelectedFoodCellsViewController?

    static func setupModule(_ foods: [Food]) -> SelectedFoodCellsViewController {
        let vc = SelectedFoodCellsViewController(foods)
        let router = SelectedFoodCellsRouter()
        vc.router = router
        router.viewController = vc
        return vc
    }
}

extension SelectedFoodCellsRouter: SelectedFoodCellsRouterInterface {
    func openProductViewController(_ product: Product) {
        let productVC = ProductRouter.setupModule(product, .addFood, .breakfast) { [weak self] food in
            self?.viewController?.updateFoods(with: food)
        }
        productVC.modalPresentationStyle = .fullScreen
        viewController?.present(productVC, animated: true)
    }
    
    func openDishViewController(_ dish: Dish) {
        let productVC = RecipePageScreenRouter.setupModule(
            with: dish,
            backButtonTitle: "Back".localized
        ) { [weak self] food in
            self?.viewController?.updateFoods(with: food)
        }
        productVC.modalPresentationStyle = .fullScreen
        viewController?.present(productVC, animated: true)
    }
    
//    func openMealViewController(_ meal: Meal) {
//        let mealVC = CreateMealRouter.setupModule(editedMeal: meal)
//        productVC.modalPresentationStyle = .fullScreen
//        viewController?.present(dishVC, animated: true)
//    }
    
    func close() {
        viewController?.dismiss(animated: true)
    }
}
