//
//  PaywallRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import UIKit

protocol PaywallRouterInterface: AnyObject {}

class PaywallRouter {
    
    // MARK: - Public properties
    
    weak var presenter: PaywallPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> PaywallViewController {
        let vc = PaywallViewController()
        let interactor = PaywallInteractor()
        let router = PaywallRouter()
        let presenter = PaywallPresenter(
            interactor: interactor,
            router: router,
            view: vc
        )

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

// MARK: - PaywallRouterInterface

extension PaywallRouter: PaywallRouterInterface {}
