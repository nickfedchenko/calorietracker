//
//  SoundsLikePlanRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import UIKit

protocol SoundsLikePlanRouterInterface: AnyObject {
    func openIncreasingYourActivityLevel()
}

class SoundsLikePlanRouter {
    
    // MARK: - Public properties
    
    weak var presenter: SoundsLikePlanPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> SoundsLikePlanViewController {
        let vc = SoundsLikePlanViewController()
        let interactor = SoundsLikePlanInteractor()
        let router = SoundsLikePlanRouter()
        let presenter = SoundsLikePlanPresenter(
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

// MARK: - SoundsLikePlanRouterInterface

extension SoundsLikePlanRouter: SoundsLikePlanRouterInterface {
    func openIncreasingYourActivityLevel() {
        let increasingYourActivityLevelRouter = IncreasingYourActivityLevelRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(increasingYourActivityLevelRouter, animated: true)
    }
}
