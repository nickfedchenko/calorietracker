//
//  EmotionalSupportSystemRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol EmotionalSupportSystemRouterInterface: AnyObject {
    func openHealthApp()
}

class EmotionalSupportSystemRouter {
    
    // MARK: - Public properties
    
    weak var presenter: EmotionalSupportSystemPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> EmotionalSupportSystemViewController {
        let vc = EmotionalSupportSystemViewController()
        let interactor = EmotionalSupportSystemInteractor(onboardingManager: OnboardingManager.shared)
        let router = EmotionalSupportSystemRouter()
        let presenter = EmotionalSupportSystemPresenter(
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

extension EmotionalSupportSystemRouter: EmotionalSupportSystemRouterInterface {
    func openHealthApp() {
        let healthAppRouter = HealthAppRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            healthAppRouter,
            animated: true
        )
    }
}
