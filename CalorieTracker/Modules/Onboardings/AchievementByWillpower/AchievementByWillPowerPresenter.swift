//
//  AchievementByWillpowerPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievementByWillPowerPresenterInterface: AnyObject {}

class AchievementByWillPowerPresenter {
    
    unowned var view: AchievementByWillPowerViewControllerInterface
    let router: AchievementByWillPowerRouterInterface?
    let interactor: AchievementByWillPowerInteractorInterface?

    init(
        interactor: AchievementByWillPowerInteractorInterface,
        router: AchievementByWillPowerRouterInterface,
        view: AchievementByWillPowerViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension AchievementByWillPowerPresenter: AchievementByWillPowerPresenterInterface {}
