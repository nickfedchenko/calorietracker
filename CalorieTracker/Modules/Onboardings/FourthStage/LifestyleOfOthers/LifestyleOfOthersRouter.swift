//
//  LifestyleOfOthersRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol LifestyleOfOthersRouterInterface: AnyObject {
    func openActivityLevelSelection()
}

class LifestyleOfOthersRouter {
    
    // MARK: - Public properties
    
    weak var presenter: LifestyleOfOthersPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> LifestyleOfOthersViewController {
        let vc = LifestyleOfOthersViewController()
        let interactor = LifestyleOfOthersInteractor(onboardingManager: OnboardingManager.shared)
        let router = LifestyleOfOthersRouter()
        let presenter = LifestyleOfOthersPresenter(
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

// MARK: - LifestyleOfOthersRouterInterface

extension LifestyleOfOthersRouter: LifestyleOfOthersRouterInterface {
    func openActivityLevelSelection() {
        let activityLevelSelectionRouter = ActivityLevelSelectionRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            activityLevelSelectionRouter,
            animated: true
        )
    }
}
