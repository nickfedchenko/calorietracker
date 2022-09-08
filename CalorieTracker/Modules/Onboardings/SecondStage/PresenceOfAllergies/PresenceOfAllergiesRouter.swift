//
//  PresenceOfAllergiesRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

protocol PresenceOfAllergiesRouterInterface: AnyObject {
    func openAllergicRestrictions()
}

class PresenceOfAllergiesRouter {
    
    // MARK: - Public properties
    
    weak var presenter: PresenceOfAllergiesPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> PresenceOfAllergiesViewController {
        let vc = PresenceOfAllergiesViewController()
        let interactor = PresenceOfAllergiesInteractor(onboardingManager: OnboardingManager.shared)
        let router = PresenceOfAllergiesRouter()
        let presenter = PresenceOfAllergiesPresenter(
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

// MARK: - PresenceOfAllergiesRouterInterface

extension PresenceOfAllergiesRouter: PresenceOfAllergiesRouterInterface {
    func openAllergicRestrictions() {
        let allergicRestrictionsRouter = AllergicRestrictionsRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(allergicRestrictionsRouter, animated: true)
    }
}
