//
//  LifeChangesAfterWeightLossRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import UIKit

protocol LifeChangesAfterWeightLossRouterInterface: AnyObject {
    func openReflectToAchievedSomethingDifficult()
}

class LifeChangesAfterWeightLossRouter {
    
    // MARK: - Public properties
    
    weak var presenter: LifeChangesAfterWeightLossPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> LifeChangesAfterWeightLossViewController {
        let vc = LifeChangesAfterWeightLossViewController()
        let interactor = LifeChangesAfterWeightLossInteractor(onboardingManager: OnboardingManager.shared)
        let router = LifeChangesAfterWeightLossRouter()
        let presenter = LifeChangesAfterWeightLossPresenter(
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

// MARK: - LifeChangesAfterWeightLossRouterInterface

extension LifeChangesAfterWeightLossRouter: LifeChangesAfterWeightLossRouterInterface {
    func openReflectToAchievedSomethingDifficult() {
        let reflectToAchievedSomethingDifficultRouter = ReflectToAchievedSomethingDifficultRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            reflectToAchievedSomethingDifficultRouter,
            animated: true
        )
    }
}
