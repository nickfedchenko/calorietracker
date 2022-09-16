//
//  PlaceOfResidenceRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol PlaceOfResidenceRouterInterface: AnyObject {
    func openEnvironmentInfluencesTheChoice()
}

class PlaceOfResidenceRouter {
    
    // MARK: - Public properties
    
    weak var presenter: PlaceOfResidencePresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> PlaceOfResidenceViewController {
        let vc = PlaceOfResidenceViewController()
        let interactor = PlaceOfResidenceInteractor(onboardingManager: OnboardingManager.shared)
        let router = PlaceOfResidenceRouter()
        let presenter = PlaceOfResidencePresenter(
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

// MARK: - PlaceOfResidenceRouterInterface

extension PlaceOfResidenceRouter: PlaceOfResidenceRouterInterface {
    func openEnvironmentInfluencesTheChoice() {
        let environmentInfluencesTheChoiceRouter = EnvironmentInfluencesTheChoiceRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            environmentInfluencesTheChoiceRouter,
            animated: true
        )
    }
}
