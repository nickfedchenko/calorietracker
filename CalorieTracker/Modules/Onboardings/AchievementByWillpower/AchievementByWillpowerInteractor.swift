//
//  AchievementByWillpowerInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievementByWillpowerInteractorInterface: AnyObject {}

class AchievementByWillpowerInteractor {
    weak var presenter: AchievingDifficultGoalPresenterInterface?
}

extension AchievementByWillpowerInteractor: AchievementByWillpowerInteractorInterface {}
