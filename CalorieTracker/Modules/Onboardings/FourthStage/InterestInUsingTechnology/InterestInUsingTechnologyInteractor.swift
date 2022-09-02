//
//  InterestInUsingTechnologyInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol InterestInUsingTechnologyInteractorInterface: AnyObject {
    func set(interestInUsingTechnology: Bool)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class InterestInUsingTechnologyInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: InterestInUsingTechnologyPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager}
}

// MARK: - InterestInUsingTechnologyInteractorInterface

extension InterestInUsingTechnologyInteractor: InterestInUsingTechnologyInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func set(interestInUsingTechnology: Bool) {
        onboardingManager.set(interestInUsingTechnology: interestInUsingTechnology)
    }
}
