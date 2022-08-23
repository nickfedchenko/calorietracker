//
//  ObsessingOverFoodRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ObsessingOverFoodRouterInterface: AnyObject {
    func openTheEffectOfWeight()
}

class ObsessingOverFoodRouter: NSObject {
    
    weak var presenter: ObsessingOverFoodPresenterInterface?
    
    static func setupModule() -> ObsessingOverFoodViewController {
        let vc = ObsessingOverFoodViewController()
        let interactor = ObsessingOverFoodInteractor()
        let router = ObsessingOverFoodRouter()
        let presenter = ObsessingOverFoodPresenter(
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

extension ObsessingOverFoodRouter: ObsessingOverFoodRouterInterface {
    func openTheEffectOfWeight() {}
}
