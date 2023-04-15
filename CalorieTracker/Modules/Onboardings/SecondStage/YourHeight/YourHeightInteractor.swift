//
//  YourHeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol YourHeightInteractorInterface: AnyObject {
    func set(yourHeight: Double)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class YourHeightInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: YourHeightPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - YourHeightInteractorInterface

extension YourHeightInteractor: YourHeightInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func set(yourHeight: Double) {
        let standartValue = BAMeasurement(yourHeight, .lenght, isMetric: UDM.lengthIsMetric).value
        onboardingManager.set(yourHeight: standartValue)
    }
}
