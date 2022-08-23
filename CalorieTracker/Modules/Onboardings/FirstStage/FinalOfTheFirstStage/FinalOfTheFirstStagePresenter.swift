//
//  FinalOfTheFirstStagePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol FinalOfTheFirstStagePresenterInterface: AnyObject {}

class FinalOfTheFirstStagePresenter {
    
    unowned var view: FinalOfTheFirstStageViewControllerInterface
    let router: FinalOfTheFirstStageRouterInterface?
    let interactor: FinalOfTheFirstStageInteractorInterface?

    init(
        interactor: FinalOfTheFirstStageInteractorInterface,
        router: FinalOfTheFirstStageRouterInterface,
        view: FinalOfTheFirstStageViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension FinalOfTheFirstStagePresenter: FinalOfTheFirstStagePresenterInterface {}
