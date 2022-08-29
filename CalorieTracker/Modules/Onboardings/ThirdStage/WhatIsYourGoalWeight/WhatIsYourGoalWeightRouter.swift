//
//  WhatIsYourGoalWeightRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import UIKit

protocol WhatIsYourGoalWeightRouterInterface: AnyObject {}

class WhatIsYourGoalWeightRouter {
    
    // MARK: - Public properties
    
    weak var presenter: WhatIsYourGoalWeightPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> WhatIsYourGoalWeightViewController {
        let vc = WhatIsYourGoalWeightViewController()
        let interactor = WhatIsYourGoalWeightInteractor()
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

extension WhatIsYourGoalWeightRouter: WhatIsYourGoalWeightRouterInterface {}
