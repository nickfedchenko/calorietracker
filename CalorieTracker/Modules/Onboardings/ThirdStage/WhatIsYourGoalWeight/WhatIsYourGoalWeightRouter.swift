//
//  WhatIsYourGoalWeightRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import UIKit

protocol WhatIsYourGoalWeightRouterInterface: AnyObject {
    func openDeficitAndSurplusCalorie()
}

class WhatIsYourGoalWeightRouter {
    
    // MARK: - Public properties
    
    weak var presenter: WhatIsYourGoalWeightPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> WhatIsYourGoalWeightViewController {
        let vc = WhatIsYourGoalWeightViewController()
        let interactor = WhatIsYourGoalWeightInteractor(onboardingManager: OnboardingManager.shared)
        let router = WhatIsYourGoalWeightRouter()
        let presenter = WhatIsYourGoalWeightPresenter(
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

// MARK: - WhatIsYourGoalWeightRouterInterface

extension WhatIsYourGoalWeightRouter: WhatIsYourGoalWeightRouterInterface {
    func openDeficitAndSurplusCalorie() {
        let deficitAndSurplusCalorieRouter = DeficitAndSurplusCalorieRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(deficitAndSurplusCalorieRouter, animated: true)
    }
}
