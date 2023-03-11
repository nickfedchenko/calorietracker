//
//  PurposeOfTheParishRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation
import Lottie
import UIKit

protocol PurposeOfTheParishRouterInterface: AnyObject {
    func openCallToAchieveGoal()
}

class PurposeOfTheParishRouter: NSObject {
    
    // MARK: - Public properties
    
    weak var presenter: PurposeOfTheParishPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> PurposeOfTheParishViewController {
        let vc = PurposeOfTheParishViewController()
        let interactor = PurposeOfTheParishInteractor(
            onboardingManager: OnboardingManager.shared)
        let router = PurposeOfTheParishRouter()
        let presenter = PurposeOfTheParishPresenter(
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

// MARK: - PurposeOfTheParishRouterInterface

extension PurposeOfTheParishRouter: PurposeOfTheParishRouterInterface {
    func openCallToAchieveGoal() {
        let callToAchieveGoalRouter = CallToAchieveGoalRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(callToAchieveGoalRouter, animated: true)
    }
}
