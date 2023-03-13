//
//  ThanksForTheInformationRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation
import UIKit

protocol ThanksForTheInformationRouterInterface: AnyObject {
    func openEnterYourName()
    func openChoseYourGoalRouter()
    func openImprovingNutrition()
}

class ThanksForTheInformationRouter: NSObject {
    
    // MARK: - Public properties

    weak var presenter: ThanksForTheInformationPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> ThanksForTheInformationViewController {
        let vc = ThanksForTheInformationViewController()
        let interactor = ThanksForTheInformationInteractor(onboardingManager: OnboardingManager.shared)
        let router = ThanksForTheInformationRouter()
        let presenter = ThanksForTheInformationPresenter(
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

// MARK: - ThanksForTheInformationRouterInterface

extension ThanksForTheInformationRouter: ThanksForTheInformationRouterInterface {
    func openEnterYourName() {
        let enterYourNameRouter = EnterYourNameRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(enterYourNameRouter, animated: true)
    }
    
    func openChoseYourGoalRouter() {
        let choseYourGoalRouter = ChooseYourGoalRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(choseYourGoalRouter, animated: true)
    }
    
    func openImprovingNutrition() {
        let improvingNutritionRouter = ImprovingNutritionRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(improvingNutritionRouter, animated: true)
    }
}
