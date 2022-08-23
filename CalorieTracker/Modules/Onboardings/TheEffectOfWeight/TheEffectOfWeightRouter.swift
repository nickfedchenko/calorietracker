//
//  TheEffectOfWeightRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol TheEffectOfWeightRouterInterface: AnyObject {}

class TheEffectOfWeightRouter: NSObject {
    
    weak var presenter: TheEffectOfWeightPresenterInterface?
    
    static func setupModule() -> TheEffectOfWeightViewController {
        let vc = TheEffectOfWeightViewController()
        let interactor = TheEffectOfWeightInteractor()
        let router = TheEffectOfWeightRouter()
        let presenter = TheEffectOfWeightPresenter(
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

extension TheEffectOfWeightRouter: TheEffectOfWeightRouterInterface {}
