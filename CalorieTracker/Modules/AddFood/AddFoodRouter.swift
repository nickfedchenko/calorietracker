//
//  AddFoodRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 28.10.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol AddFoodRouterInterface: AnyObject {
    func closeViewController()
    func openProductViewController(_ product: Product)
    func openSelectedFoodCellsVC(_ foods: [Food], complition: @escaping ([Food]) -> Void )
    func openScanner()
    func openCreateProduct()
    func openDishViewController(_ dish: Dish) 
}

class AddFoodRouter: NSObject {

    weak var presenter: AddFoodPresenterInterface?
    weak var viewController: UIViewController?
    var needUpdate: (() -> Void)?

    static func setupModule(
        shouldInitiallyPerformSearchWith barcode: String? = nil,
        mealTime: MealTime = .breakfast,
        addFoodYCoordinate: CGFloat,
        needUpdate: (() -> Void)? = nil
    ) -> AddFoodViewController {
      
        let vc = AddFoodViewController(searchFieldYCoordinate: addFoodYCoordinate)
        let interactor = AddFoodInteractor()
        let router = AddFoodRouter()
        let presenter = AddFoodPresenter(interactor: interactor, router: router, view: vc)
        let keyboardManager = KeyboardManager()
        vc.presenter = presenter
        vc.keyboardManager = keyboardManager
        vc.mealTime = mealTime
        router.presenter = presenter
        router.viewController = vc
        router.needUpdate = needUpdate
        interactor.presenter = presenter
        defer {
            if let barcode = barcode {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    presenter.scannerDidRecognized(barcode: barcode)
                }
            }
        }
        return vc
    }
}

extension AddFoodRouter: AddFoodRouterInterface {
    func closeViewController() {
        needUpdate?()
        print("Nav controller contains \(viewController?.navigationController?.viewControllers)")
        print("Nav delegate is \(viewController?.navigationController?.delegate)")
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
    
    func openProductViewController(_ product: Product) {
        let productVC = ProductRouter.setupModule(
            product,
            .addFood,
            presenter?.getMealTime() ?? .breakfast
        ) { [weak self] food in
            self?.presenter?.updateSelectedFood(food: food)
        }
        productVC.modalPresentationStyle = .fullScreen
        viewController?.navigationController?.present(productVC, animated: true)
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
        viewController?.present(vc, animated: true)
    }
    
    func openDishViewController(_ dish: Dish) {
        let vc = RecipePageScreenRouter.setupModule(
            with: dish,
            backButtonTitle: "Add food".localized
        ) { [weak self] food in
            self?.presenter?.updateSelectedFood(food: food)
        }
        vc.modalPresentationStyle = .fullScreen
        viewController?.navigationController?.present(vc, animated: true)
    }
}
