//
//  ObsessingOverFoodRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation
import UIKit

protocol ObsessingOverFoodRouterInterface: AnyObject {
    func openFormationGoodHabits()
}

class ObsessingOverFoodRouter: NSObject {
    
    // MARK: - Public properties

    weak var presenter: ObsessingOverFoodPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> ObsessingOverFoodViewController {
        let vc = ObsessingOverFoodViewController()
        let interactor = ObsessingOverFoodInteractor(onboardingManager: OnboardingManager.shared)
        let router = ObsessingOverFoodRouter()
        let presenter = ObsessingOverFoodPresenter(
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

// MARK: - ObsessingOverFoodRouterInterface

extension ObsessingOverFoodRouter: ObsessingOverFoodRouterInterface {
    func openFormationGoodHabits() {
        let formationGoodHabitsRouter = FormationGoodHabitsRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(formationGoodHabitsRouter, animated: true)
    }
}
