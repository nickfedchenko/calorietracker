//
//  FinalOfTheSecondStageRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol FinalOfTheSecondStageRouterInterface: AnyObject {}

class FinalOfTheSecondStageRouter {
    
    // MARK: - Public properties

    weak var presenter: FinalOfTheSecondStagePresenterInterface?
    
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
        interactor.presenter = presenter
        return vc
    }
}

// MARK: - FinalOfTheSecondStageRouterInterface

extension FinalOfTheSecondStageRouter: FinalOfTheSecondStageRouterInterface {}
