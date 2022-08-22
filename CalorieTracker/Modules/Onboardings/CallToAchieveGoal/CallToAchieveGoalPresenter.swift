//
//  CallToAchieveGoalPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol CallToAchieveGoalPresenterInterface: AnyObject {}

class CallToAchieveGoalPresenter {
    
    unowned var view: CallToAchieveGoalViewControllerInterface
    let router: CallToAchieveGoalRouterInterface?
    let interactor: CallToAchieveGoalInteractorInterface?

    init(
        interactor: CallToAchieveGoalInteractorInterface,
        router: CallToAchieveGoalRouterInterface,
        view: CallToAchieveGoalViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension CallToAchieveGoalPresenter: CallToAchieveGoalPresenterInterface {}
