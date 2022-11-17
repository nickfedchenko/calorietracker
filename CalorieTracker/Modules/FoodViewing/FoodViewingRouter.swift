//
//  FoodViewingRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol FoodViewingRouterInterface: AnyObject {
    func closeViewController()
}

class FoodViewingRouter: NSObject {

    weak var presenter: FoodViewingPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule() -> FoodViewingViewController {
        let vc = FoodViewingViewController()
        let interactor = FoodViewingInteractor()
        let router = FoodViewingRouter()
        let presenter = FoodViewingPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension FoodViewingRouter: FoodViewingRouterInterface {
    func closeViewController() {
        viewController?.dismiss(animated: true)
    }
}
