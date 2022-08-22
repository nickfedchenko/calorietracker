//
//  AchievingDifficultGoalInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievingDifficultGoalInteractorInterface: AnyObject {}

class AchievingDifficultGoalInteractor {
    weak var presenter: AchievingDifficultGoalPresenterInterface?
}

extension AchievingDifficultGoalInteractor: AchievingDifficultGoalInteractorInterface {}
