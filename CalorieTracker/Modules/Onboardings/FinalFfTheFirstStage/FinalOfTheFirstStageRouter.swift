//
//  FinalOfTheFirstStageRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol FinalOfTheFirstStageRouterInterface: AnyObject {
    
}

class FinalOfTheFirstStageRouter: NSObject {
    
    weak var presenter: FinalOfTheFirstStagePresenterInterface?
    
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
        interactor.presenter = presenter
        return vc
    }
}

extension FinalOfTheFirstStageRouter: FinalOfTheFirstStageRouterInterface {
    
}
