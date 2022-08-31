//
//  ThoughtsOnStressEatingRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import UIKit

protocol ThoughtsOnStressEatingRouterInterface: AnyObject {
    func openHelpingPeopleTrackCalories()
}

class ThoughtsOnStressEatingRouter {
    
    // MARK: - Public properties
    
    weak var presenter: ThoughtsOnStressEatingPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> ThoughtsOnStressEatingViewController {
        let vc = ThoughtsOnStressEatingViewController()
        let interactor = ThoughtsOnStressEatingInteractor(
            onboardingManager: OnboardingManager.shared
        )
        let router = ThoughtsOnStressEatingRouter()
        let presenter = ThoughtsOnStressEatingPresenter(
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

// MARK: - ThoughtsOnStressEatingRouterInterface

extension ThoughtsOnStressEatingRouter: ThoughtsOnStressEatingRouterInterface {
    func openHelpingPeopleTrackCalories() {
        let helpingPeopleTrackCaloriesRouter = HelpingPeopleTrackCaloriesRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            helpingPeopleTrackCaloriesRouter,
            animated: true
        )
    }
}
