//
//  LastCalorieCountRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol LastCalorieCountRouterInterface: AnyObject {
    func openCalorieCount()
}

class LastCalorieCountRouter: NSObject {
    
    weak var presenter: LastCalorieCountPresenterInterface?
    
    static func setupModule() -> LastCalorieCountViewController {
        let vc = LastCalorieCountViewController()
        let interactor = LastCalorieCountInteractor()
        let router = LastCalorieCountRouter()
        let presenter = LastCalorieCountPresenter(
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

extension LastCalorieCountRouter: LastCalorieCountRouterInterface {
    func openCalorieCount() {}
}
