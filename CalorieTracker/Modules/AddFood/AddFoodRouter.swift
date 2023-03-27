//
//  AddFoodRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 28.10.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import ApphudSDK
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
    func dismissToCreateMeal(with food: Food)
}

enum AddFoodnavigationType {
    case navigationController, modal
}

class AddFoodRouter: NSObject {

    weak var presenter: AddFoodPresenterInterface?
    weak var viewController: UIViewController?
    var needUpdate: (() -> Void)?
    var wasFromMealCreateVC: Bool = false
    var didSelectFood: ((Food) -> Void)?
    var needShowReviewController: (() -> Void)?
    var navigationType: AddFoodnavigationType = .modal

    static func setupModule(
        shouldInitiallyPerformSearchWith barcode: String? = nil,
        mealTime: MealTime = .breakfast,
        addFoodYCoordinate: CGFloat,
        needUpdate: (() -> Void)? = nil,
        needShowReviewController: (() -> Void)? = nil,
        tabBarIsHidden: Bool? = false,
        searchRequest: String? = nil,
        wasFromMealCreateVC: Bool = false,
        didSelectFood: ((Food) -> Void)? = nil,
        navigationType: AddFoodnavigationType
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
        router.navigationType = navigationType
        router.wasFromMealCreateVC = wasFromMealCreateVC
        router.needShowReviewController = needShowReviewController
//        router.didSelectProduct = didSelectProduct
//        router.didSelectDish = didSelectDish
        router.didSelectFood = didSelectFood
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
                if !(self?.wasFromMealCreateVC ?? false) {
                    self?.presenter?.updateSelectedFoodFromSearch(food: food)
                } else {
                    self?.viewController?.dismiss(animated: false) { [weak self] in
                        self?.didSelectFood?(food)
                    }
                }
            }
        )
        if navigationType == .modal {
            productVC.modalPresentationStyle = .fullScreen
            viewController?.present(productVC, animated: true)
        } else {
            viewController?.navigationController?.pushViewController(productVC, animated: true)
        }
       
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
        guard Apphud.hasActiveSubscription() else {
            let paywall = PaywallRouter.setupModule()
            paywall.modalPresentationStyle = .fullScreen
            viewController?.navigationController?.present(paywall, animated: true)
            return
        }
        let vc = ScannerRouter.setupModule { [weak self] barcode in
            self?.presenter?.scannerDidRecognized(barcode: barcode)
        }
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
        LoggingService.postEvent(event: .diaryscanfromtabbar)
    }
    
    func openCreateProduct() {
        guard !wasFromMealCreateVC else { return }
        if UDM.openCreateProductCounter >= 1 {
//            guard Apphud.hasActiveSubscription() else {
//                let paywall = PaywallRouter.setupModule()
//                paywall.modalPresentationStyle = .fullScreen
//                viewController?.navigationController?.present(paywall, animated: true)
//                return
//            }
            LoggingService.postEvent(event: .diarycreatefood)
            let vc = CreateProductRouter.setupModule()
            vc.modalPresentationStyle = .overFullScreen
            viewController?.present(vc, animated: true)
            LoggingService.postEvent(event: .diarycreatefood)
        } else {
            let vc = CreateProductRouter.setupModule()
            vc.modalPresentationStyle = .overFullScreen
            viewController?.present(vc, animated: true)
            UDM.openCreateProductCounter += 1
            LoggingService.postEvent(event: .diarycreatefood)
        }
    }
    
    func openDishViewController(_ dish: Dish) {
        let vc = RecipePageScreenRouter.setupModule(
            with: dish,
            backButtonTitle: "Add food".localized,
            openController: wasFromMealCreateVC == true ? .createMeal : .addToDiary,
            addToDiaryHandler: { [weak self] food in
                if !(self?.wasFromMealCreateVC ?? false) {
                    self?.presenter?.updateSelectedFoodFromSearch(food: food)
                } else {
                    self?.viewController?.dismiss(animated: false) { [weak self] in
                        self?.didSelectFood?(food)
                    }
                }
            }
        )
        
        vc.modalPresentationStyle = .fullScreen
        if navigationType == .modal {
            viewController?.navigationController?.present(vc, animated: true)
        } else {
            viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openCustomEntryViewController(mealTime: MealTime) {
        guard Apphud.hasActiveSubscription() else {
            let paywall = PaywallRouter.setupModule()
            paywall.modalPresentationStyle = .fullScreen
            viewController?.navigationController?.present(paywall, animated: true)
            return
        }
        let vc = CustomEntryViewController(mealTime: mealTime)
        
        vc.onSavedCustomEntry = { [weak self] customEntry in
            self?.presenter?.updateSelectedFoodFromCustomEntry(food: .customEntry(customEntry))
            self?.presenter?.updateCustomFood(food: .customEntry(customEntry))
            LoggingService.postEvent(event: .diarycustomadd)
        }
        
        vc.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.present(vc, animated: true)
        LoggingService.postEvent(event: .diarycustom)
    }
    
    func openCreateMeal(mealTime: MealTime) {
        guard Apphud.hasActiveSubscription() else {
            let paywall = PaywallRouter.setupModule()
            paywall.modalPresentationStyle = .fullScreen
            viewController?.navigationController?.present(paywall, animated: true)
            return
        }
        
        let vc = CreateMealRouter.setupModule(mealTime: mealTime)
        
        vc.needToUpdate = { [weak self] in
            self?.presenter?.realoadCollectionView()
        }
        
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
        LoggingService.postEvent(event: .diarycreatemeal)
    }
    
    func openEditMeal(meal: Meal) {
        let vc = CreateMealRouter.setupModule(editedMeal: meal)
        
        vc.needToUpdate = { [weak self] in
            self?.presenter?.realoadCollectionView()
        }
        
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func dismissVC() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func dismissToCreateMeal(with food: Food) {
        viewController?.dismiss(animated: false) { [weak self] in
            self?.didSelectFood?(food)
        }
    }
    
}
