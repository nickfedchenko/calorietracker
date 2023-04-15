//
//  OpenMainWidgetRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 02.02.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import UIKit

protocol OpenMainWidgetRouterInterface: AnyObject {
    func closeVC()
    func openAddFoodVC(_ mealTime: MealTime)
    func openFoodVC(_ food: Food)
}

class OpenMainWidgetRouter: NSObject {

    weak var presenter: OpenMainWidgetPresenterInterface?
    weak var viewController: UIViewController?
    var needUpdate: (() -> Void)?

    static func setupModule(_ date: Date, needUpdate: (() -> Void)? = nil) -> OpenMainWidgetViewController {
        let vc = OpenMainWidgetViewController()
        let interactor = OpenMainWidgetInteractor()
        let router = OpenMainWidgetRouter()
        let presenter = OpenMainWidgetPresenter(
            interactor: interactor,
            router: router,
            view: vc,
            date: date
        )

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        router.needUpdate = needUpdate
        interactor.presenter = presenter
        return vc
    }
}

extension OpenMainWidgetRouter: OpenMainWidgetRouterInterface {
    func closeVC() {
        needUpdate?()
        viewController?.dismiss(animated: true)
    }
    
    func openAddFoodVC(_ mealTime: MealTime) {
        let vc = AddFoodRouter.setupModule(
            mealTime: mealTime,
            addFoodYCoordinate: UDM.mainScreenAddButtonOriginY,
            needUpdate: { [weak self] in
                self?.presenter?.updateDailyMeals()
            },
            navigationType: .navigationController,
            shouldSuggestMealTime: false
        )
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openFoodVC(_ food: Food) {
        switch food {
        case .product(let product, _, _):
            let productVC = ProductRouter.setupModule(
                product,
                .createProduct,
                .breakfast
            ) { [weak self] food in
                
            }
            productVC.callViewWillAppear = false
//            productVC.modalPresentationStyle = .overFullScreen
            viewController?.navigationController?.pushViewController(productVC, animated: true)
        case .dishes(let dish, _):
            let vc = RecipePageScreenRouter.setupModule(
                with: dish,
                backButtonTitle: "Add food".localized
            ) { [weak self] food in
                
            }
//            vc.modalPresentationStyle = .fullScreen
            viewController?.navigationController?.pushViewController(vc, animated: true)
        case .meal:
            break
        case .customEntry:
            break
        }
    }
}
