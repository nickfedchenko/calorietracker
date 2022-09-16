//
//  InterestInUsingTechnologyRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import UIKit

protocol InterestInUsingTechnologyRouterInterface: AnyObject {
    func openPlaceOfResidence()
}

class InterestInUsingTechnologyRouter {
    
    // MARK: - Public properties
    
    weak var presenter: InterestInUsingTechnologyPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> InterestInUsingTechnologyViewController {
        let vc = InterestInUsingTechnologyViewController()
        let interactor = InterestInUsingTechnologyInteractor(
            onboardingManager: OnboardingManager.shared
        )
        let router = InterestInUsingTechnologyRouter()
        let presenter = InterestInUsingTechnologyPresenter(
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

// MARK: - InterestInUsingTechnologyRouterInterface

extension InterestInUsingTechnologyRouter: InterestInUsingTechnologyRouterInterface {
    func openPlaceOfResidence() {
        let placeOfResidenceRouter = PlaceOfResidenceRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            placeOfResidenceRouter,
            animated: true
        )
    }
}
