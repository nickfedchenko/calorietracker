//
//  AchievementByWillpowerInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievementByWillPowerInteractorInterface: AnyObject {}

class AchievementByWillPowerInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: AchievementByWillPowerPresenterInterface?
}

// MARK: - AchievementByWillPowerInteractorInterface

extension AchievementByWillPowerInteractor: AchievementByWillPowerInteractorInterface {}
