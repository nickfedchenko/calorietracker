//
//  EnterYourNameRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 25.08.2022.
//

import UIKit

protocol EnterYourNameRouterInterface: AnyObject {
    func openWhatsYourGender()
}

class EnterYourNameRouter {
    
    // MARK: - Public properties
    
    weak var presenter: EnterYourNamePresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> EnterYourNameViewController {
        let vc = EnterYourNameViewController()
        let interactor = EnterYourNameInteractor(onboardingManager: OnboardingManager.shared)
        let router = EnterYourNameRouter()
        let presenter = EnterYourNamePresenter(
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

// MARK: - EnterYourNameRouterInterface

extension EnterYourNameRouter: EnterYourNameRouterInterface {
    func openWhatsYourGender() {
        let whatsYourGenderRouter = WhatsYourGenderRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(whatsYourGenderRouter, animated: true)
    }
}
