//
//  PreviousApplicationRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol PreviousApplicationRouterInterface: AnyObject {}

class PreviousApplicationRouter: NSObject {
    
    weak var presenter: PreviousApplicationPresenterInterface?
    
    static func setupModule() -> PreviousApplicationViewController {
        let vc = PreviousApplicationViewController()
        let interactor = PreviousApplicationInteractor()
        let router = PreviousApplicationRouter()
        let presenter = PreviousApplicationPresenter(
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

extension PreviousApplicationRouter: PreviousApplicationRouterInterface {}
