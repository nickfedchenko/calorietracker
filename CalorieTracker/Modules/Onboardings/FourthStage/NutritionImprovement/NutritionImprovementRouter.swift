//
//  NutritionImprovementRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import UIKit

protocol NutritionImprovementRouterInterface: AnyObject {}

class NutritionImprovementRouter {
    
    // MARK: - Public properties
    
    weak var presenter: NutritionImprovementPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> NutritionImprovementViewController {
        let vc = NutritionImprovementViewController()
        let interactor = NutritionImprovementInteractor(
            onboardingManager: OnboardingManager.shared
        )
        let router = NutritionImprovementRouter()
        let presenter = NutritionImprovementPresenter(
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

extension NutritionImprovementRouter: NutritionImprovementRouterInterface {}
