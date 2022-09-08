//
//  FinalOfTheFirstStageRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import UIKit

protocol FinalOfTheFirstStageRouterInterface: AnyObject {
    func openEnterYourName()
}

class FinalOfTheFirstStageRouter: NSObject {
    
    // MARK: - Public properties

    weak var presenter: FinalOfTheFirstStagePresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> FinalOfTheFirstStageViewController {
        let vc = FinalOfTheFirstStageViewController()
        let interactor = FinalOfTheFirstStageInteractor()
        let router = FinalOfTheFirstStageRouter()
        let presenter = FinalOfTheFirstStagePresenter(
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

// MARK: - FinalOfTheFirstStageRouterInterface

extension FinalOfTheFirstStageRouter: FinalOfTheFirstStageRouterInterface {
    func openEnterYourName() {
        let enterYourNameRouter = EnterYourNameRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(enterYourNameRouter, animated: true)
    }
}
