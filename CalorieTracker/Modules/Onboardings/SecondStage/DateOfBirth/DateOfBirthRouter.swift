//
//  DateOfBirthRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import UIKit

protocol DateOfBirthRouterInterface: AnyObject {
    func openYourHeight()
}

class DateOfBirthRouter {
    
    // MARK: - Public properties
    
    weak var presenter:  DateOfBirthPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> DateOfBirthViewController {
        let vc = DateOfBirthViewController()
        let interactor = DateOfBirthInteractor(onboardingManager: OnboardingManager.shared)
        let router = DateOfBirthRouter()
        let presenter = DateOfBirthPresenter(
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

// MARK: - DateOfBirthRouterInterface

extension DateOfBirthRouter: DateOfBirthRouterInterface {
    func openYourHeight() {
        let yourHeightRouter = YourHeightRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(yourHeightRouter, animated: true)
    }
}
