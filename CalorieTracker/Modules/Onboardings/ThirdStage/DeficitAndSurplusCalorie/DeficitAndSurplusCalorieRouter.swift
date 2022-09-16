//
//  DeficitAndSurplusCalorieRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 05.09.2022.
//

import UIKit

protocol DeficitAndSurplusCalorieRouterInterface: AnyObject {
    func openThanksForTheInformation()
}

class DeficitAndSurplusCalorieRouter {
    
    // MARK: - Public properties
    
    weak var presenter: DeficitAndSurplusCaloriePresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> DeficitAndSurplusCalorieViewController {
        let vc = DeficitAndSurplusCalorieViewController()
        let interactor = DeficitAndSurplusCalorieInteractor(onboardingManager: OnboardingManager.shared,
                                                            weightChartService: WeightChartServiceImp())
        let router = DeficitAndSurplusCalorieRouter()
        let presenter = DeficitAndSurplusCaloriePresenter(
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

extension DeficitAndSurplusCalorieRouter: DeficitAndSurplusCalorieRouterInterface {
    func openThanksForTheInformation() {
        let thanksForTheInformationRouter = ThanksForTheInformationRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(thanksForTheInformationRouter, animated: true)
    }
}
