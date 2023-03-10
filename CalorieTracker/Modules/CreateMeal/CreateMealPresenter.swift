//
//  CreateMealPresenter.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 27.02.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Foundation

protocol CreateMealPresenterInterface: AnyObject {
    func didTapAddFood(with searchRequest: String)
    func addProduct(_ product: Product)
    func removeFood(at index: Int)
    func addDish(_ dish: Dish)
    func saveMeal(mealTime: MealTime, title: String, photoURL: URL)
    func addFoods(from meal: Meal)
    func setChildMeal(for meal: Meal)
}

class CreateMealPresenter {

    unowned var view: CreateMealViewControllerInterface
    let router: CreateMealRouterInterface?
    let interactor: CreateMealInteractorInterface?
    
    var foods: [Food]? {
        didSet {
            view.setFoods(foods ?? [])
        }
    }
    
    init(
        interactor: CreateMealInteractorInterface,
        router: CreateMealRouterInterface,
        view: CreateMealViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.foods = []
    }
}

extension CreateMealPresenter: CreateMealPresenterInterface {
    func didTapAddFood(with searchRequest: String) {
        router?.openAddFoodVC(with: searchRequest)
    }
    
    func addProduct(_ product: Product) {
        foods?.append(.product(product, customAmount: nil, unit: nil))
    }
    
    func addDish(_ dish: Dish) {
        foods?.append(.dishes(dish, customAmount: nil))
    }
    
    func addCustomEntry(_ customEntry: CustomEntry) {
        foods?.append(.customEntry(customEntry))
    }
    
    func removeFood(at index: Int) {
        foods?.remove(at: index)
    }
    
    func saveMeal(mealTime: MealTime, title: String, photoURL: URL) {
        FDS.shared.createMeal(
            mealTime: mealTime,
            title: title,
            photoURL: photoURL.absoluteString,
            foods: foods ?? [])
    }
    
    func addFoods(from meal: Meal) {
        meal.products.foods.forEach { foods?.append($0) }
        meal.dishes.foods.forEach { foods?.append($0) }
        meal.customEntries.foods.forEach { foods?.append($0) }
    }
    
    func setChildMeal(for meal: Meal) {
        let dishesID = foods?.dishes.map { $0.id } ?? []
        let productsID = foods?.products.map { $0.id } ?? []
        DSF.shared.setChildMeal(
            mealId: meal.id,
            dishesID: dishesID,
            productsID: productsID,
            customEntriesID: [])
    }
}
