//
//  AllergicRestrictionsRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

protocol AllergicRestrictionsRouterInterface: AnyObject {
    func openThanksForTheInformation()
}

class AllergicRestrictionsRouter {
    
    // MARK: - Public properties
    
    weak var presenter: AllergicRestrictionsPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> AllergicRestrictionsViewController {
        let vc = AllergicRestrictionsViewController()
        let interactor = AllergicRestrictionsInteractor(onboardingManager: OnboardingManager.shared)
        let router = AllergicRestrictionsRouter()
        let presenter = AllergicRestrictionsPresenter(
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

// MARK: - AllergicRestrictionsRouterInterface

extension AllergicRestrictionsRouter: AllergicRestrictionsRouterInterface {
    func openThanksForTheInformation() {
        let thanksForTheInformationRouter = ThanksForTheInformationRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(thanksForTheInformationRouter, animated: true)
    }
}
