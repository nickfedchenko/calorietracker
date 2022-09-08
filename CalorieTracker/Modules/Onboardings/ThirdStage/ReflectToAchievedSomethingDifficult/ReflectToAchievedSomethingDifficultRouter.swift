//
//  ReflectToAchievedSomethingDifficultRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import UIKit

protocol ReflectToAchievedSomethingDifficultRouterInterface: AnyObject {
    func openTimeToSeeYourGoalWeight()
}

class ReflectToAchievedSomethingDifficultRouter {
    
    // MARK: - Public properties
    
    weak var presenter: ReflectToAchievedSomethingDifficultPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> ReflectToAchievedSomethingDifficultViewController {
        let vc = ReflectToAchievedSomethingDifficultViewController()
        let interactor = ReflectToAchievedSomethingDifficultInteractor(onboardingManager: OnboardingManager.shared)
        let router = ReflectToAchievedSomethingDifficultRouter()
        let presenter = ReflectToAchievedSomethingDifficultPresenter(
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

// MARK: - ReflectToAchievedSomethingDifficultRouterInterface

extension ReflectToAchievedSomethingDifficultRouter: ReflectToAchievedSomethingDifficultRouterInterface {
    func openTimeToSeeYourGoalWeight() {
        let timeToSeeYourGoalWeightRouter = TimeToSeeYourGoalWeightRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(timeToSeeYourGoalWeightRouter, animated: true)
    }
}
