//
//  HelpingPeopleTrackCaloriesRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import UIKit

protocol HelpingPeopleTrackCaloriesRouterInterface: AnyObject {
    func openStressAndEmotionsAreInevitable()
}

class HelpingPeopleTrackCaloriesRouter {
    
    // MARK: - Public properties
    
    weak var presenter: HelpingPeopleTrackCaloriesPresenter?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> HelpingPeopleTrackCaloriesViewController {
        let vc = HelpingPeopleTrackCaloriesViewController()
        let interactor = HelpingPeopleTrackCaloriesInteractor(onboardingManager: OnboardingManager.shared)
        let router = HelpingPeopleTrackCaloriesRouter()
        let presenter = HelpingPeopleTrackCaloriesPresenter(
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

// MARK: - HelpingPeopleTrackCaloriesRouterInterface

extension HelpingPeopleTrackCaloriesRouter: HelpingPeopleTrackCaloriesRouterInterface {
    func openStressAndEmotionsAreInevitable() {
        let stressAndEmotionsAreInevitableRouter = StressAndEmotionsAreInevitableRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            stressAndEmotionsAreInevitableRouter,
            animated: true
        )
    }
}
