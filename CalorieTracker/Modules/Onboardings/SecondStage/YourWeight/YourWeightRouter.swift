//
//  YourWeightRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

protocol YourWeightRouterInterface: AnyObject {
    func openRisksOfDiseases()
}

class YourWeightRouter {
    
    // MARK: - Public properties
    
    weak var presenter: YourWeightPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> YourWeightViewController {
        let vc = YourWeightViewController()
        let interactor = YourWeightInteractor(onboardingManager: OnboardingManager.shared)
        let router = YourWeightRouter()
        let presenter = YourWeightPresenter(
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

// MARK: - YourWeightRouterInterface

extension YourWeightRouter: YourWeightRouterInterface {
    func openRisksOfDiseases() {
        let risksOfDiseasesRouter = RisksOfDiseasesRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(risksOfDiseasesRouter, animated: true)
    }
}
