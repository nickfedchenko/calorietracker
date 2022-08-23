//
//  ObsessingOverFoodPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ObsessingOverFoodPresenterInterface: AnyObject {
    func didTapAnswerOption()
}

class ObsessingOverFoodPresenter {
    
    unowned var view: ObsessingOverFoodViewControllerInterface
    let router: ObsessingOverFoodRouterInterface?
    let interactor: ObsessingOverFoodInterctorInterface?

    init(
        interactor: ObsessingOverFoodInterctorInterface,
        router: ObsessingOverFoodRouterInterface,
        view: ObsessingOverFoodViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ObsessingOverFoodPresenter: ObsessingOverFoodPresenterInterface {
    func didTapAnswerOption() {
        router?.openTheEffectOfWeight()
    }
}
