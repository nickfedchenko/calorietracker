//
//  WhatIsYourGoalWeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol WhatIsYourGoalWeightInteractorInterface: AnyObject {
    func set(whatIsYourGoalWeight: Double)
    func getCurrentOnboardingStage() -> OnboardingStage
    func getWeightRange() -> Double
}

class WhatIsYourGoalWeightInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: WhatIsYourGoalWeightPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - WhatIsYourGoalWeightInteractorInterface

extension WhatIsYourGoalWeightInteractor: WhatIsYourGoalWeightInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func set(whatIsYourGoalWeight: Double) {
        onboardingManager.set(whatIsYourGoalWeight: whatIsYourGoalWeight)
    }
    
    func getWeightRange() -> Double {
        let currentWeight = onboardingManager.getYourWeight()
        let goal = onboardingManager.getYourGoal()
        
        switch goal {
        case .loseWeight:
            return ((currentWeight ?? 0.0) * 0.85).rounded()
        case .gainMuscleMass:
            return ((currentWeight ?? 0.0) * 1.15).rounded()
        default:
            return currentWeight ?? 0.0
        }
    }
}
