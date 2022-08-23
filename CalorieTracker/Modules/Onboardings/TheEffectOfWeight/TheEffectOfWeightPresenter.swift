//
//  TheEffectOfWeightPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol TheEffectOfWeightPresenterInterface: AnyObject {}

class TheEffectOfWeightPresenter {
    
    unowned var view: TheEffectOfWeightViewControllerInterface
    let router: TheEffectOfWeightRouterInterface?
    let interactor: TheEffectOfWeightInteractorInterface?

    init(
        interactor: TheEffectOfWeightInteractorInterface,
        router: TheEffectOfWeightRouterInterface,
        view: TheEffectOfWeightViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TheEffectOfWeightPresenter: TheEffectOfWeightPresenterInterface {}
