//
//  TimeToSeeYourGoalWeightRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import UIKit

protocol TimeToSeeYourGoalWeightRouterInterface: AnyObject {
    func openWhatIsYourGoalWeight()
}

class TimeToSeeYourGoalWeightRouter {
    
    // MARK: - Public properties
    
    weak var presenter: TimeToSeeYourGoalWeightPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> TimeToSeeYourGoalWeightViewController {
        let vc = TimeToSeeYourGoalWeightViewController()
        let interactor = TimeToSeeYourGoalWeightInteractor(onboardingManager: OnboardingManager.shared)
        let router = TimeToSeeYourGoalWeightRouter()
        let presenter = TimeToSeeYourGoalWeightPresenter(
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

// MARK: - TimeToSeeYourGoalWeightRouterInterface

extension TimeToSeeYourGoalWeightRouter: TimeToSeeYourGoalWeightRouterInterface {
    func openWhatIsYourGoalWeight() {
        let whatIsYourGoalWeightRouter = WhatIsYourGoalWeightRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(whatIsYourGoalWeightRouter, animated: true)
    }
}
