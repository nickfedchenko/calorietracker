//
//  FinalOfTheSecondStageRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import UIKit

protocol FinalOfTheSecondStageRouterInterface: AnyObject {
    func openImportanceOfWeightLoss()
}

class FinalOfTheSecondStageRouter {
    
    // MARK: - Public properties

    weak var presenter: FinalOfTheSecondStagePresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> FinalOfTheSecondStageViewController {
        let vc = FinalOfTheSecondStageViewController()
        let interactor = FinalOfTheSecondStageInteractor()
        let router = FinalOfTheSecondStageRouter()
        let presenter = FinalOfTheSecondStagePresenter(
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

// MARK: - FinalOfTheSecondStageRouterInterface

extension FinalOfTheSecondStageRouter: FinalOfTheSecondStageRouterInterface {
    func openImportanceOfWeightLoss() {
        let importanceOfWeightLossRouter = ImportanceOfWeightLossRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(importanceOfWeightLossRouter, animated: true)
    }
}
