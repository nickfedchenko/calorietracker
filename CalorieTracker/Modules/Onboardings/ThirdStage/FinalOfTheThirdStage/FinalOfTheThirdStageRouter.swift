//
//  FinalOfTheThirdStageRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import UIKit

protocol FinalOfTheThirdStageRouterInterface: AnyObject {
    func openCurrentLifestile()
}

class FinalOfTheThirdStageRouter {
    
    // MARK: - Public properties
    
    weak var presenter: FinalOfTheThirdStagePresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> FinalOfTheThirdStageViewController {
        let vc = FinalOfTheThirdStageViewController()
        let interactor = FinalOfTheThirdStageInteractor()
        let router = FinalOfTheThirdStageRouter()
        let presenter = FinalOfTheThirdStagePresenter(
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

// MARK: - FinalOfTheThirdStageRouterInterface

extension FinalOfTheThirdStageRouter: FinalOfTheThirdStageRouterInterface {
    func openCurrentLifestile() {
        let currentLifestileRouter = CurrentLifestileRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(currentLifestileRouter, animated: true)
    }
}
