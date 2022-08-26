//
//  WhatsYourGenderRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 25.08.2022.
//

import UIKit

protocol WhatsYourGenderRouterInterface: AnyObject {
    func openMeasurementSystem()
}

class WhatsYourGenderRouter {
    
    // MARK: - Public properties
    
    weak var presenter: WhatsYourGenderPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> WhatsYourGenderViewController {
        let vc = WhatsYourGenderViewController()
        let interactor = WhatsYourGenderInteractor(onboardingManager: OnboardingManager.shared)
        let router = WhatsYourGenderRouter()
        let presenter = WhatsYourGenderPresenter(
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

// MARK: - WelcomeRouterInterface

extension WhatsYourGenderRouter: WhatsYourGenderRouterInterface {
    func openMeasurementSystem() {
        let measurementSystemRouter = MeasurementSystemRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(measurementSystemRouter, animated: true)
    }
}
