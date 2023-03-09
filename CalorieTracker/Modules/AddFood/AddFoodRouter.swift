//
//  AddFoodRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 28.10.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol AddFoodRouterInterface: AnyObject {
    func closeViewController(shouldAskForReview: Bool)
    func openProductViewController(_ product: Product)
    func openSelectedFoodCellsVC(_ foods: [Food], complition: @escaping ([Food]) -> Void )
    func openScanner()
    func openCreateProduct()
    func openDishViewController(_ dish: Dish)
    func openCreateMeal(mealTime: MealTime)
    func openCustomEntryViewController(mealTime: MealTime)
    func dismissVC()
    func openEditMeal(meal: Meal)
    func dismissToCreateMeal(with product: Product)
    func dismissToCreateMeal(with dish: Dish)
}

class AddFoodRouter: NSObject {

    weak var presenter: AddFoodPresenterInterface?
    weak var viewController: UIViewController?
    var needUpdate: (() -> Void)?
    var wasFromMealCreateVC: Bool?
    var didSelectProduct: ((Product) -> Void)?
    var didSelectDish: ((Dish) -> Void)?
    var needShowReviewController: (() -> Void)?

    static func setupModule(
        shouldInitiallyPerformSearchWith barcode: String? = nil,
        mealTime: MealTime = .breakfast,
        addFoodYCoordinate: CGFloat,
        needUpdate: (() -> Void)? = nil,
        needShowReviewController: (() -> Void)? = nil,
        tabBarIsHidden: Bool? = false,
        searchRequest: String? = nil,
        wasFromMealCreateVC: Bool? = false,
        didSelectProduct: ((Product) -> Void)? = nil,
        didSelectDish: ((Dish) -> Void)? = nil
    ) -> AddFoodViewController {
      
        let vc = AddFoodViewController(searchFieldYCoordinate: addFoodYCoordinate)
        let interactor = AddFoodInteractor()
        let router = AddFoodRouter()
        let presenter = AddFoodPresenter(interactor: interactor, router: router, view: vc)
        let keyboardManager = KeyboardManager()
        vc.presenter = presenter
        vc.keyboardManager = keyboardManager
        vc.mealTime = mealTime
        vc.tabBarIsHidden = tabBarIsHidden ?? false
        vc.searchText = searchRequest
        vc.wasFromMealCreateVC = wasFromMealCreateVC ?? false
        router.presenter = presenter
        router.viewController = vc
        router.needUpdate = needUpdate
        router.wasFromMealCreateVC = wasFromMealCreateVC
        router.needShowReviewController = needShowReviewController
        router.didSelectProduct = didSelectProduct
        router.didSelectDish = didSelectDish
        interactor.presenter = presenter
        defer {
            if let barcode = barcode {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    presenter.scannerDidRecognized(barcode: barcode)
                }
            }
        }
        
        defer {
            if let searchRequest {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    presenter.search(searchRequest, complition: nil)
                }
            }
        }
        return vc
    }
}

extension AddFoodRouter: AddFoodRouterInterface {
    func closeViewController(shouldAskForReview: Bool = false) {
        viewController?.navigationController?.popToRootViewController(animated: true)
        needUpdate?()
        if shouldAskForReview {
            needShowReviewController?()
        }
    }
    
    func openProductViewController(_ product: Product) {
        let productVC = ProductRouter.setupModule(
            product,
            wasFromMealCreateVC == true ? .createMeal : .addFood,
            presenter?.getMealTime() ?? .breakfast,
            { [weak self] food in
                self?.presenter?.updateSelectedFoodFromSearch(food: food)
            },
            { [weak self] product in
                self?.viewController?.dismiss(animated: false) { [weak self] in
                    self?.didSelectProduct?(product)
                }
            }
        )
        
        productVC.modalPresentationStyle = .fullScreen
        viewController?.present(productVC, animated: true)
    }
    
    func openSelectedFoodCellsVC(
        _ foods: [Food],
        complition: @escaping ([Food]) -> Void
    ) {
        let vc = SelectedFoodCellsRouter.setupModule(foods)
//        vc.modalPresentationStyle = .fullScreen
        vc.didChangeSeletedFoods = { newFoods in
            complition(newFoods)
        }
        vc.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.present(vc, animated: true)
    }
    
    func openScanner() {
        let vc = ScannerRouter.setupModule() { [weak self] barcode in
            self?.presenter?.scannerDidRecognized(barcode: barcode)
        }
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func openCreateProduct() {
        let vc = CreateProductRouter.setupModule()
        vc.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.present(vc, animated: true)
    }
    
    func openDishViewController(_ dish: Dish) {
        let vc = RecipePageScreenRouter.setupModule(
            with: dish,
            backButtonTitle: "Add food".localized,
            openController: wasFromMealCreateVC == true ? .createMeal : .addToDiary,
            addToDiaryHandler: { [weak self] food in
                self?.presenter?.updateSelectedFoodFromSearch(food: food)
            },
            dishSelectionHandler: { [weak self] dish in
                self?.viewController?.dismiss(animated: false) { [weak self] in
                    self?.didSelectDish?(dish)
                }
            }
        )
        
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func openCustomEntryViewController(mealTime: MealTime) {
        let vc = CustomEntryViewController(mealTime: mealTime)
        
        vc.onSavedCustomEntry = { [weak self] customEntry in
            self?.presenter?.updateSelectedFoodFromCustomEntry(food: .customEntry(customEntry))
            self?.presenter?.updateCustomFood(food: .customEntry(customEntry))
        }
        
        vc.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.present(vc, animated: true)
    }
    
    func openCreateMeal(mealTime: MealTime) {
        let vc = CreateMealRouter.setupModule(mealTime: mealTime)
        
        vc.needToUpdate = { [weak self] in
            self?.presenter?.setFoodType(.myMeals)
        }
        
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func openEditMeal(meal: Meal) {
        let vc = CreateMealRouter.setupModule(editedMeal: meal)
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func dismissVC() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func dismissToCreateMeal(with product: Product) {
        viewController?.dismiss(animated: false) { [weak self] in
            self?.didSelectProduct?(product)
        }
    }

    func dismissToCreateMeal(with dish: Dish) {
        viewController?.dismiss(animated: false) { [weak self] in
            self?.didSelectDish?(dish)
        }
    }
    
}
