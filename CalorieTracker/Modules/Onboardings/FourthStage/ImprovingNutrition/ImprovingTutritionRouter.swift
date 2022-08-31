//
//  ImprovingTutritionRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import UIKit

protocol ImprovingNutritionRouterInterface: AnyObject {
    func openSoundsLikePlan()
}

class ImprovingNutritionRouter {
    
    // MARK: - Public properties
    
    weak var presenter: ImprovingNutritionPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> ImprovingNutritionViewController {
        let vc = ImprovingNutritionViewController()
        let interactor = ImprovingNutritionInteractor(onboardingManager: OnboardingManager.shared)
        let router = ImprovingNutritionRouter()
        let presenter = ImprovingNutritionPresenter(
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

// MARK: - ImprovingNutritionRouterInterface

extension ImprovingNutritionRouter: ImprovingNutritionRouterInterface {
    func openSoundsLikePlan() {
        let soundsLikePlanRouter = SoundsLikePlanRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(soundsLikePlanRouter, animated: true)
    }
}
