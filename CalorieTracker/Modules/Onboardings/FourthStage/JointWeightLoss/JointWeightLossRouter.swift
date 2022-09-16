//
//  JointWeightLossRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol JointWeightLossRouterInterface: AnyObject {
    func openDifficultyOfMakingHealthyChoices()
}

class JointWeightLossRouter {
    
    // MARK: - Public properties
    
    weak var presenter: JointWeightLossPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> JointWeightLossViewController {
        let vc = JointWeightLossViewController()
        let interactor = JointWeightLossInteractor(onboardingManager: OnboardingManager.shared)
        let router = JointWeightLossRouter()
        let presenter = JointWeightLossPresenter(
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

// MARK: - JointWeightLossRouterInterface

extension JointWeightLossRouter: JointWeightLossRouterInterface {
    func openDifficultyOfMakingHealthyChoices() {
        let difficultyOfMakingHealthyChoices = DifficultyOfMakingHealthyChoicesRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            difficultyOfMakingHealthyChoices,
            animated: true
        )
    }
}
