//
//  AchievementByWillpowerInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievementByWillPowerInteractorInterface: AnyObject {}

class AchievementByWillPowerInteractor {
    weak var presenter: AchievementByWillPowerPresenterInterface?
}

extension AchievementByWillPowerInteractor: AchievementByWillPowerInteractorInterface {}
