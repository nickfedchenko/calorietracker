//
//  ProductRouter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol ProductRouterInterface: AnyObject {
    func closeViewController()
}

class ProductRouter: NSObject {

    weak var presenter: ProductPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule(_ product: Product) -> ProductViewController {
        let vc = ProductViewController()
        let interactor = ProductInteractor()
        let router = ProductRouter()
        let presenter = ProductPresenter(interactor: interactor,
                                             router: router,
                                             view: vc,
                                             product: product)

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension ProductRouter: ProductRouterInterface {
    func closeViewController() {
        viewController?.dismiss(animated: true)
    }
}
