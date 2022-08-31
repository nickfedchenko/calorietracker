//
//  DifficultyOfMakingHealthyChoicesRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol DifficultyOfMakingHealthyChoicesRouterInterface: AnyObject {
    func openLifestyleOfOthers()
}

class DifficultyOfMakingHealthyChoicesRouter {
    
    // MARK: - Public properties
    
    weak var presenter: DifficultyOfMakingHealthyChoicesPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> DifficultyOfMakingHealthyChoicesViewController {
        let vc = DifficultyOfMakingHealthyChoicesViewController()
        let interactor = DifficultyOfMakingHealthyChoicesInteractor()
        let router = DifficultyOfMakingHealthyChoicesRouter()
        let presenter = DifficultyOfMakingHealthyChoicesPresenter(
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

// MARK: - DifficultyOfMakingHealthyChoicesRouterInterface

extension DifficultyOfMakingHealthyChoicesRouter: DifficultyOfMakingHealthyChoicesRouterInterface {
    func openLifestyleOfOthers() {
        let lifestyleOfOthers = LifestyleOfOthersRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            lifestyleOfOthers,
            animated: true
        )
    }
}
