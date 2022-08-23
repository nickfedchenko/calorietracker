//
//  ThanksForTheInformationRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

import Foundation

protocol ThanksForTheInformationRouterInterface: AnyObject {
    
}

class ThanksForTheInformationRouter: NSObject {
    
    weak var presenter: ThanksForTheInformationPresenterInterface?
    
    static func setupModule() -> ThanksForTheInformationViewController {
        let vc = ThanksForTheInformationViewController()
        let interactor = ThanksForTheInformationInteractor()
        let router = ThanksForTheInformationRouter()
        let presenter = ThanksForTheInformationPresenter(
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

extension ThanksForTheInformationRouter: ThanksForTheInformationRouterInterface {
    
}
