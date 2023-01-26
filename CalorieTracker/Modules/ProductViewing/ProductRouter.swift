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
}

class ProductRouter: NSObject {

    weak var presenter: ProductPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule(
        _ product: Product,
        _ openController: ProductViewController.OpenController
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
        interactor.presenter = presenter
        interactor.product = product
        return vc
    }
}

extension ProductRouter: ProductRouterInterface {
    func closeViewController(_ animated: Bool) {
        viewController?.dismiss(animated: true)
    }
}
