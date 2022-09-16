//
//  PreviousApplicationRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation
import UIKit

protocol PreviousApplicationRouterInterface: AnyObject {
    func openObsessingOverFood()
}

class PreviousApplicationRouter: NSObject {
    
    // MARK: - Public properties

    weak var presenter: PreviousApplicationPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> PreviousApplicationViewController {
        let vc = PreviousApplicationViewController()
        let interactor = PreviousApplicationInteractor(onboardingManager: OnboardingManager.shared)
        let router = PreviousApplicationRouter()
        let presenter = PreviousApplicationPresenter(
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

extension PreviousApplicationRouter: PreviousApplicationRouterInterface {
    func openObsessingOverFood() {
        let obsessingOverFoodRouter = ObsessingOverFoodRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(obsessingOverFoodRouter, animated: true)
    }
}