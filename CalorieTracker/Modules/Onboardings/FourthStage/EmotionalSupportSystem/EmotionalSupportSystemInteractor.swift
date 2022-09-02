//
//  EmotionalSupportSystemInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol EmotionalSupportSystemInteractorInterface: AnyObject {
    func getAllEmotionalSupportSystem() -> [EmotionalSupportSystem]
    func set(emotionalSupportSystem: EmotionalSupportSystem)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class EmotionalSupportSystemInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: EmotionalSupportSystemPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - EmotionalSupportSystemInteractorInterface

extension EmotionalSupportSystemInteractor: EmotionalSupportSystemInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllEmotionalSupportSystem() -> [EmotionalSupportSystem] {
        return onboardingManager.getAllEmotionalSupportSystem()
    }
    
    func set(emotionalSupportSystem: EmotionalSupportSystem) {
        onboardingManager.set(emotionalSupportSystem: emotionalSupportSystem)
    }
}
