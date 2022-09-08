//
//  ImportanceOfWeightLossRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import UIKit

protocol ImportanceOfWeightLossRouterInterface: AnyObject {
    func openThoughtsAboutChangingFeelings()
}

class ImportanceOfWeightLossRouter {
    
    // MARK: - Public properties
    
    weak var presenter: ImportanceOfWeightLossPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> ImportanceOfWeightLossViewController {
        let vc = ImportanceOfWeightLossViewController()
        let interactor = ImportanceOfWeightLossInteractor(onboardingManager: OnboardingManager.shared)
        let router = ImportanceOfWeightLossRouter()
        let presenter = ImportanceOfWeightLossPresenter(
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

// MARK: - ImportanceOfWeightLossRouterInterface

extension ImportanceOfWeightLossRouter: ImportanceOfWeightLossRouterInterface {
    func openThoughtsAboutChangingFeelings() {
        let thoughtsAboutChangingFeelingsRouter = ThoughtsAboutChangingFeelingsRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(thoughtsAboutChangingFeelingsRouter, animated: true)
    }
}
