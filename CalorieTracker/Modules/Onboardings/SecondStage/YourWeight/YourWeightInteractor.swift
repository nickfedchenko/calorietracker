//
//  YourWeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol YourWeightInteractorInterface: AnyObject {
    func set(yourWeight: Double)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class YourWeightInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: YourWeightPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - YourWeightInteractorInterface

extension YourWeightInteractor: YourWeightInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {        
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func set(yourWeight: Double) {
        onboardingManager.set(yourWeight: yourWeight)
    }
}
