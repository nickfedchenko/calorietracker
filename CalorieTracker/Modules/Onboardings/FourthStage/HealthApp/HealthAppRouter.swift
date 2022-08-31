//
//  HealthAppRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import UIKit

protocol HealthAppRouterInterface: AnyObject {
    func openFinalOfTheFourthStage()
}

class HealthAppRouter {
    
    // MARK: - Public properties
    
    weak var presenter: HealthAppPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> HealthAppViewController {
        let vc = HealthAppViewController()
        let interactor = HealthAppInteractor()
        let router = HealthAppRouter()
        let presenter = HealthAppPresenter(
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

extension HealthAppRouter: HealthAppRouterInterface {
    func openFinalOfTheFourthStage() {
        let finalOfTheFourthStageRouter = FinalOfTheFourthStageRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(
            finalOfTheFourthStageRouter,
            animated: true
        )
    }
}
