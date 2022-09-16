//
//  ThoughtsAboutChangingFeelingsRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import UIKit

protocol ThoughtsAboutChangingFeelingsRouterInterface: AnyObject {
    func openLifeChangesAfterWeightLoss()
}

class ThoughtsAboutChangingFeelingsRouter {
    
    // MARK: - Public properties
    
    weak var presenter: ThoughtsAboutChangingFeelingsPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> ThoughtsAboutChangingFeelingsViewController {
        let vc = ThoughtsAboutChangingFeelingsViewController()
        let interactor = ThoughtsAboutChangingFeelingsInteractor(onboardingManager: OnboardingManager.shared)
        let router = ThoughtsAboutChangingFeelingsRouter()
        let presenter = ThoughtsAboutChangingFeelingsPresenter(
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

// MARK: - ThoughtsAboutChangingFeelingsRouterInterface

extension ThoughtsAboutChangingFeelingsRouter: ThoughtsAboutChangingFeelingsRouterInterface {
    func openLifeChangesAfterWeightLoss() {
        let lifeChangesAfterWeightLossRouter = LifeChangesAfterWeightLossRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(lifeChangesAfterWeightLossRouter, animated: true)
    }
}
