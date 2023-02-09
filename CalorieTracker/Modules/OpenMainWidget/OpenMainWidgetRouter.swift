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
}

class OpenMainWidgetRouter: NSObject {

    weak var presenter: OpenMainWidgetPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule(_ date: Date) -> OpenMainWidgetViewController {
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
        interactor.presenter = presenter
        return vc
    }
}

extension OpenMainWidgetRouter: OpenMainWidgetRouterInterface {
    func closeVC() {
        viewController?.dismiss(animated: true)
    }
    
    func openAddFoodVC(_ mealTime: MealTime) {
        let vc = AddFoodRouter.setupModule(mealTime: mealTime)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
