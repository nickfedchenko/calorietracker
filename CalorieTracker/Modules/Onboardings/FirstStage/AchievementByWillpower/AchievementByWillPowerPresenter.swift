//
//  AchievementByWillpowerPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievementByWillPowerPresenterInterface: AnyObject {
    func didTapNextCommonButton()
}

class AchievementByWillPowerPresenter {
    
    // MARK: - Public properties
    
    unowned var view: AchievementByWillPowerViewControllerInterface
    let router: AchievementByWillPowerRouterInterface?
    let interactor: AchievementByWillPowerInteractorInterface?

    // MARK: - Initialization
    
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

// MARK: - AchievementByWillPowerPresenterInterface

extension AchievementByWillPowerPresenter: AchievementByWillPowerPresenterInterface {
    func didTapNextCommonButton() {
        router?.openLastCalorieCount()
    }
}
