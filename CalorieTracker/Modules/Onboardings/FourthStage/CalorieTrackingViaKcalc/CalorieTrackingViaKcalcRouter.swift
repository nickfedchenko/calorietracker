//
//  CalorieTrackingViaKcalcRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol CalorieTrackingViaKcalcRouterInterface: AnyObject {
    func openPaywallController()
}

class CalorieTrackingViaKcalcRouter {
    
    // MARK: - Public properties
    
    weak var presenter: CalorieTrackingViaKcalcPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> CalorieTrackingViaKcalcViewController {
        let vc = CalorieTrackingViaKcalcViewController()
        let interactor = CalorieTrackingViaKcalcInteractor()
        let router = CalorieTrackingViaKcalcRouter()
        let presenter = CalorieTrackingViaKcalcPresenter(
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

// MARK: - CalorieTrackingViaKcalcRouterInterface

extension CalorieTrackingViaKcalcRouter: CalorieTrackingViaKcalcRouterInterface {
    func openPaywallController() {
        let vc = PaywallRouter.setupModule()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
