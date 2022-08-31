//
//  HealthAppPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol HealthAppPresenterInterface: AnyObject {
    func didTapContinueCommonButton()
}

class HealthAppPresenter {
    
    // MARK: - Public properties

    unowned var view: HealthAppViewControllerInterface
    let router: HealthAppRouterInterface?
    let interactor: HealthAppInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: HealthAppInteractorInterface,
        router: HealthAppRouterInterface,
        view: HealthAppViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension HealthAppPresenter: HealthAppPresenterInterface {
    func didTapContinueCommonButton() {
        router?.openFinalOfTheFourthStage()
    }
}
