//
//  WhatImportantToYouRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import UIKit

protocol WhatImportantToYouRouterInterface: AnyObject {
    func openBestDescriptionOfTheSituation()
}

class WhatImportantToYouRouter {
    
    // MARK: - Public properties
    
    weak var presenter: WhatImportantToYouPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> WhatImportantToYouViewController {
        let vc = WhatImportantToYouViewController()
        let interactor = WhatImportantToYouInteractor(
            onboardingManager: OnboardingManager.shared
        )
        let router = WhatImportantToYouRouter()
        let presenter = WhatImportantToYouPresenter(
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

// MARK: - WhatImportantToYouRouterInterface

extension WhatImportantToYouRouter: WhatImportantToYouRouterInterface {
    func openBestDescriptionOfTheSituation() {
        let bestDescriptionOfTheSituationRouter = BestDescriptionOfTheSituationRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            bestDescriptionOfTheSituationRouter,
            animated: true
        )
    }
}
