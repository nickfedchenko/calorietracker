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
}

class AddFoodRouter: NSObject {

    weak var presenter: AddFoodPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule() -> AddFoodViewController {
        let vc = AddFoodViewController()
        let interactor = AddFoodInteractor()
        let router = AddFoodRouter()
        let presenter = AddFoodPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
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
}
