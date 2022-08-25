//
//  AchievingDifficultGoalInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol AchievingDifficultGoalInteractorInterface: AnyObject {
    func getAllAchievingDifficultGoal() -> [AchievingDifficultGoal]
    func set(achievingDifficultGoal: AchievingDifficultGoal)
}

class AchievingDifficultGoalInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: AchievingDifficultGoalPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - AchievingDifficultGoalInteractorInterface

extension AchievingDifficultGoalInteractor: AchievingDifficultGoalInteractorInterface {
    func getAllAchievingDifficultGoal() -> [AchievingDifficultGoal] {
        return onboardingManager.getAllAchievingDifficultGoal()
    }
    
    func set(achievingDifficultGoal: AchievingDifficultGoal) {
        onboardingManager.set(achievingDifficultGoal: achievingDifficultGoal)
    }
}
