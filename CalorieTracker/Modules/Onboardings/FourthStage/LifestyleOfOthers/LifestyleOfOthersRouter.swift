//
//  LifestyleOfOthersRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol LifestyleOfOthersRouterInterface: AnyObject {
    func navigateNext()
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
    func navigateNext() {
        let finalOfTheFourthStageRouter = FinalOfTheFourthStageRouter.setupModule()
        viewController?.navigationController?.pushViewController(finalOfTheFourthStageRouter, animated: true)
    }
}
