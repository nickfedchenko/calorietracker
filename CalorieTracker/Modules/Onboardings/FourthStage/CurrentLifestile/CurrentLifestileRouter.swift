//
//  CurrentLifestileRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import UIKit

protocol CurrentLifestileRouterInterface: AnyObject {
    func openNutritionImprovement()
}

class CurrentLifestileRouter {
    
    // MARK: - Public properties
    
    weak var presenter: CurrentLifestilePresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> CurrentLifestileViewController {
        let vc = CurrentLifestileViewController()
        let interactor = CurrentLifestileInteractor(onboardingManager: OnboardingManager.shared)
        let router = CurrentLifestileRouter()
        let presenter = CurrentLifestilePresenter(
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

extension CurrentLifestileRouter: CurrentLifestileRouterInterface {
    func openNutritionImprovement() {
        let nutritionImprovementRouter = NutritionImprovementRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(nutritionImprovementRouter, animated: true)
    }
}
