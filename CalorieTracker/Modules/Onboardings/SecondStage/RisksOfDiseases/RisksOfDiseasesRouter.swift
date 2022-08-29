//
//  RisksOfDiseasesRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

protocol RisksOfDiseasesRouterInterface: AnyObject {
    func openPresenceOfAllergies()
}

class RisksOfDiseasesRouter {
    
    // MARK: - Public properties
    
    weak var presenter: RisksOfDiseasesPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> RisksOfDiseasesViewController {
        let vc = RisksOfDiseasesViewController()
        let interactor = RisksOfDiseasesInteractor(onboardingManager: OnboardingManager.shared)
        let router = RisksOfDiseasesRouter()
        let presenter = RisksOfDiseasesPresenter(
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

extension RisksOfDiseasesRouter: RisksOfDiseasesRouterInterface {
    func openPresenceOfAllergies() {
        let presenceOfAllergiesRouter = PresenceOfAllergiesRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(presenceOfAllergiesRouter, animated: true)
    }
}
