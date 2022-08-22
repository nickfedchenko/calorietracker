//
//  AchievingDifficultGoalPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievingDifficultGoalPresenterInterface: AnyObject {}

class AchievingDifficultGoalPresenter {
    
    unowned var view: AchievingDifficultGoalViewControllerInterface
    let router: AchievingDifficultGoalRouterInterface?
    let interactor: AchievingDifficultGoalInteractorInterface?

    init(
        interactor: AchievingDifficultGoalInteractorInterface,
        router: AchievingDifficultGoalRouterInterface,
        view: AchievingDifficultGoalViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension AchievingDifficultGoalPresenter: AchievingDifficultGoalPresenterInterface {}
