//
//  BestDescriptionOfTheSituationRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol BestDescriptionOfTheSituationRouterInterface: AnyObject {
    func openTimeForYourself()
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
    func openTimeForYourself() {
        let timeForYourselfRouter = TimeForYourselfRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            timeForYourselfRouter,
            animated: true
        )
    }
}
