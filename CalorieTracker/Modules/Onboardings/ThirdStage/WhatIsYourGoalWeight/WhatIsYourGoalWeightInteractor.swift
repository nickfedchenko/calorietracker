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
}
