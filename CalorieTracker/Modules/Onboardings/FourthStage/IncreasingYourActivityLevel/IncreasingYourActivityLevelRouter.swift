//
//  IncreasingYourActivityLevelRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import UIKit

protocol IncreasingYourActivityLevelRouterInterface: AnyObject {
    func openHowImproveYourEfficiency()
}

class IncreasingYourActivityLevelRouter {
    
    // MARK: - Public properties
    
    weak var presenter: IncreasingYourActivityLevelPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> IncreasingYourActivityLevelViewController {
        let vc = IncreasingYourActivityLevelViewController()
        let interactor = IncreasingYourActivityLevelInteractor(onboardingManager: OnboardingManager.shared)
        let router = IncreasingYourActivityLevelRouter()
        let presenter = IncreasingYourActivityLevelPresenter(
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

// MARK: - IncreasingYourActivityLevelRouterInterface

extension IncreasingYourActivityLevelRouter: IncreasingYourActivityLevelRouterInterface {
    func openHowImproveYourEfficiency() {
        let howImproveYourEfficiencyRouter = HowImproveYourEfficiencyRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(howImproveYourEfficiencyRouter, animated: true)
    }
}
