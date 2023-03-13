//
//  BestDescriptionOfTheSituationRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol BestDescriptionOfTheSituationRouterInterface: AnyObject {
    func openEmotionalSupportSystem()
}

class BestDescriptionOfTheSituationRouter {
    
    // MARK: - Public properties
    
    weak var presenter: BestDescriptionOfTheSituationPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> BestDescriptionOfTheSituationViewController {
        let vc = BestDescriptionOfTheSituationViewController()
        let interactor = BestDescriptionOfTheSituationInteractor(onboardingManager: OnboardingManager.shared)
        let router = BestDescriptionOfTheSituationRouter()
        let presenter = BestDescriptionOfTheSituationPresenter(
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

// MARK: - BestDescriptionOfTheSituationRouterInterface

extension BestDescriptionOfTheSituationRouter: BestDescriptionOfTheSituationRouterInterface {
    func openEmotionalSupportSystem() {
        let emotionalSupportSystemRouter = EmotionalSupportSystemRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            emotionalSupportSystemRouter,
            animated: true
        )
    }
}
