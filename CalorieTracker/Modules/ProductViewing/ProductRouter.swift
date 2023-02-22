//
//  ProductRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol ProductRouterInterface: AnyObject {
    func closeViewController(_ animated: Bool)
    func addToDiary(_ food: Food)
}

class ProductRouter: NSObject {

    weak var presenter: ProductPresenterInterface?
    weak var viewController: UIViewController?
    var addToDiaryHandler: ((Food) -> Void)?

    static func setupModule(
        _ product: Product,
        _ openController: ProductViewController.OpenController,
        _ mealTime: MealTime,
        _ addToDiaryHandler: ((Food) -> Void)? = nil
    ) -> ProductViewController {
        let vc = ProductViewController(openController)
        let interactor = ProductInteractor()
        let router = ProductRouter()
        let keyboardManager = KeyboardManager()
        let presenter = ProductPresenter(interactor: interactor,
                                         router: router,
                                         view: vc)

        vc.presenter = presenter
        vc.keyboardManager = keyboardManager
        router.presenter = presenter
        router.viewController = vc
        router.addToDiaryHandler = addToDiaryHandler
        interactor.presenter = presenter
        interactor.product = product
        interactor.mealTime = mealTime
        return vc
    }
}

extension ProductRouter: ProductRouterInterface {
    func closeViewController(_ animated: Bool) {
        if viewController?.navigationController != nil {
            viewController?.navigationController?.popViewController(animated: true)
        } else {
            viewController?.dismiss(animated: true)
        }
    }
    
    func addToDiary(_ food: Food) {
        addToDiaryHandler?(food)
    }
}
