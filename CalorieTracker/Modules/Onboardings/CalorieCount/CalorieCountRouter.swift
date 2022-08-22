//
//  CalorieCountRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol CalorieCountRouterInterface: AnyObject {
    func openPreviousApplication()
}

class CalorieCountRouter: NSObject {
    
    weak var presenter: CalorieCountPresenterInterface?
    
    static func setupModule() -> CalorieCountViewController {
        let vc = CalorieCountViewController()
        let interactor = CalorieCountInteractor()
        let router = CalorieCountRouter()
        let presenter = CalorieCountPresenter(
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

extension CalorieCountRouter: CalorieCountRouterInterface {
    func openPreviousApplication() {}
}
