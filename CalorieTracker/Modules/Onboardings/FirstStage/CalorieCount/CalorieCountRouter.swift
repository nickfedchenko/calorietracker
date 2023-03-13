//
//  CalorieCountRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation
import UIKit

protocol CalorieCountRouterInterface: AnyObject {
    func openLastCalorieCount()
    func openObsessingOverFood()
}

class CalorieCountRouter: NSObject {
    
    // MARK: - Public properties

    weak var presenter: CalorieCountPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> CalorieCountViewController {
        let vc = CalorieCountViewController()
        let interactor = CalorieCountInteractor(
            onboardingManager: OnboardingManager.shared)
        let router = CalorieCountRouter()
        let presenter = CalorieCountPresenter(
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

// MARK: - CalorieCountRouterInterface

extension CalorieCountRouter: CalorieCountRouterInterface {
    func openLastCalorieCount() {
        let lastCalorieCountRouter = LastCalorieCountRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(lastCalorieCountRouter, animated: true)
    }
    
    func openObsessingOverFood() {
        let obsessingOverFoodRouter = ObsessingOverFoodRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(obsessingOverFoodRouter, animated: true)
    }
}
