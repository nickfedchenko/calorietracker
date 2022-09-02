//
//  ReflectToAchievedSomethingDifficultInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol ReflectToAchievedSomethingDifficultInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
}

class ReflectToAchievedSomethingDifficultInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: ReflectToAchievedSomethingDifficultPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - ReflectToAchievedSomethingDifficultInteractorInterface

extension ReflectToAchievedSomethingDifficultInteractor: ReflectToAchievedSomethingDifficultInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
}
