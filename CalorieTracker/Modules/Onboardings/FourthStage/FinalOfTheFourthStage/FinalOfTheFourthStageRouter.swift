//
//  FinalOfTheFourthStageRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol FinalOfTheFourthStageRouterInterface: AnyObject {
    func didTapCalorieTrackingViaKcalc()
}

class FinalOfTheFourthStageRouter {
    // MARK: - Public properties
    
    weak var presenter: FinalOfTheFourthStagePresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> FinalOfTheFourthStageViewController {
        let vc = FinalOfTheFourthStageViewController()
        let interactor = FinalOfTheFourthStageInteractor()
        let router = FinalOfTheFourthStageRouter()
        let presenter = FinalOfTheFourthStagePresenter(
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

extension FinalOfTheFourthStageRouter: FinalOfTheFourthStageRouterInterface {
    func didTapCalorieTrackingViaKcalc() {
        let calorieTrackingViaKcalcRouter = CalorieTrackingViaKcalcRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            calorieTrackingViaKcalcRouter,
            animated: true
        )
    }
}
