//
//  LastCalorieCountRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation
import UIKit

protocol LastCalorieCountRouterInterface: AnyObject {
    func openPreviousApplication()
    func openObsessingOverFood()
}

class LastCalorieCountRouter: NSObject {
    
    // MARK: - Public properties
    
    weak var presenter: LastCalorieCountPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> LastCalorieCountViewController {
        let vc = LastCalorieCountViewController()
        let interactor = LastCalorieCountInteractor(
            onboardingManager: OnboardingManager.shared)
        let router = LastCalorieCountRouter()
        let presenter = LastCalorieCountPresenter(
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
// MARK: - LastCalorieCountRouterInterface

extension LastCalorieCountRouter: LastCalorieCountRouterInterface {
    func openPreviousApplication() {
        let previousApplicationRouter = PreviousApplicationRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(previousApplicationRouter, animated: true)
    }
    
    func openObsessingOverFood() {
        let obsessingOverFoodRouter = ObsessingOverFoodRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(obsessingOverFoodRouter, animated: true)
    }
}
