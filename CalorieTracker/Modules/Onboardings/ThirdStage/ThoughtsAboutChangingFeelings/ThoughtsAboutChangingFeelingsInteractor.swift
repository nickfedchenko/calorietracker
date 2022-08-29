//
//  ThoughtsAboutChangingFeelingsInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol ThoughtsAboutChangingFeelingsInteractorInterface: AnyObject {
    func getAllThoughtsAboutChangingFeelings() -> [ThoughtsAboutChangingFeelings]
    func set(thoughtsAboutChangingFeelings: ThoughtsAboutChangingFeelings)
}

class ThoughtsAboutChangingFeelingsInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: ThoughtsAboutChangingFeelingsPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - ThoughtsAboutChangingFeelingsInteractorInterface

extension ThoughtsAboutChangingFeelingsInteractor: ThoughtsAboutChangingFeelingsInteractorInterface {
    func getAllThoughtsAboutChangingFeelings() -> [ThoughtsAboutChangingFeelings] {
        return onboardingManager.getAllThoughtsAboutChangingFeelings()
    }
    
    func set(thoughtsAboutChangingFeelings: ThoughtsAboutChangingFeelings) {
        onboardingManager.set(thoughtsAboutChangingFeelings: thoughtsAboutChangingFeelings)
    }
}
