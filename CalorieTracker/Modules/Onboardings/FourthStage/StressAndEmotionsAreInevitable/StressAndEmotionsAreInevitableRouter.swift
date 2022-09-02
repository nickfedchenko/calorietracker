//
//  StressAndEmotionsAreInevitableRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import UIKit

protocol StressAndEmotionsAreInevitableRouterInterface: AnyObject {
    func openYoureNotAlone()
}

class StressAndEmotionsAreInevitableRouter {
    
    // MARK: - Public properties
    
    weak var presenter: StressAndEmotionsAreInevitablePresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> StressAndEmotionsAreInevitableViewController {
        let vc = StressAndEmotionsAreInevitableViewController()
        let interactor = StressAndEmotionsAreInevitableInteractor(onboardingManager: OnboardingManager.shared)
        let router = StressAndEmotionsAreInevitableRouter()
        let presenter = StressAndEmotionsAreInevitablePresenter(
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

// MARK: - StressAndEmotionsAreInevitableRouterInterface

extension StressAndEmotionsAreInevitableRouter: StressAndEmotionsAreInevitableRouterInterface {
    func openYoureNotAlone() {
        let youreNotAloneRouter = YoureNotAloneRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            youreNotAloneRouter,
            animated: true
        )
    }
}
