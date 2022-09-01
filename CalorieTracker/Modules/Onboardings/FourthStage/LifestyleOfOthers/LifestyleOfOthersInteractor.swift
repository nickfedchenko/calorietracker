//
//  LifestyleOfOthersInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol LifestyleOfOthersInteractorInterface: AnyObject {
    func getAllLifestyleOfOthers() -> [LifestyleOfOthers]
    func set(lifestyleOfOthers: LifestyleOfOthers)
}

class LifestyleOfOthersInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: LifestyleOfOthersPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - LifestyleOfOthersInteractorInterface

extension LifestyleOfOthersInteractor: LifestyleOfOthersInteractorInterface {
    func getAllLifestyleOfOthers() -> [LifestyleOfOthers] {
        return onboardingManager.getAllLifestyleOfOthers()
    }
    
    func set(lifestyleOfOthers: LifestyleOfOthers) {
        onboardingManager.set(lifestyleOfOthers: lifestyleOfOthers)
    }
}
