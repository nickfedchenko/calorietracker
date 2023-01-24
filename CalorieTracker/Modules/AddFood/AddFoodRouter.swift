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

    static func setupModule() -> AddFoodViewController {
        let vc = AddFoodViewController()
        let interactor = AddFoodInteractor()
        let router = AddFoodRouter()
        let presenter = AddFoodPresenter(interactor: interactor, router: router, view: vc)
        let keyboardManager = KeyboardManager()

        vc.presenter = presenter
        vc.keyboardManager = keyboardManager
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension AddFoodRouter: AddFoodRouterInterface {
    func closeViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func openProductViewController(_ product: Product) {
        let productVC = ProductRouter.setupModule(product, .addFood)
        productVC.modalPresentationStyle = .fullScreen
        viewController?.present(productVC, animated: true)
    }
    
    func openSelectedFoodCellsVC(
        _ foods: [Food],
        complition: @escaping ([Food]) -> Void
    ) {
        let vc = SelectedFoodCellsRouter.setupModule(foods)
        vc.modalPresentationStyle = .overFullScreen
        vc.didChangeSeletedFoods = { newFoods in
            complition(newFoods)
        }
        
        viewController?.present(vc, animated: true)
    }
    
    func openScanner() {
        let vc = ScannerRouter.setupModule()
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
            backButtonTitle: ""
        )
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
}
