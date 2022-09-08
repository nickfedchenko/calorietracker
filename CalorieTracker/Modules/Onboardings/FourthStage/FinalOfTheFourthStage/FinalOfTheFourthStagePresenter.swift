//
//  FinalOfTheFourthStagePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol FinalOfTheFourthStagePresenterInterface: AnyObject {
    func didTapContinueCommonButton()
}

class FinalOfTheFourthStagePresenter {
    
    // MARK: - Public properties

    unowned var view: FinalOfTheFourthStageViewControllerInterface
    let router: FinalOfTheFourthStageRouterInterface?
    let interactor: FinalOfTheFourthStageInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: FinalOfTheFourthStageInteractorInterface,
        router: FinalOfTheFourthStageRouterInterface,
        view: FinalOfTheFourthStageViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - FinalOfTheFourthStagePresenterInterface

extension FinalOfTheFourthStagePresenter: FinalOfTheFourthStagePresenterInterface {
    func didTapContinueCommonButton() {
        router?.didTapCalorieTrackingViaKcalc()
    }
}
