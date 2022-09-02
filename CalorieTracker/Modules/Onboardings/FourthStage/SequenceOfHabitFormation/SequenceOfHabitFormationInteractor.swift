//
//  SequenceOfHabitFormationInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol SequenceOfHabitFormationInteractorInterface: AnyObject {
    func getAllSequenceOfHabitFormation() -> [SequenceOfHabitFormation]
    func set(sequenceOfHabitFormation: SequenceOfHabitFormation)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class SequenceOfHabitFormationInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: SequenceOfHabitFormationPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - SequenceOfHabitFormationInteractorInterface

extension SequenceOfHabitFormationInteractor: SequenceOfHabitFormationInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllSequenceOfHabitFormation() -> [SequenceOfHabitFormation] {
        return onboardingManager.getAllSequenceOfHabitFormation()
    }
    
    func set(sequenceOfHabitFormation: SequenceOfHabitFormation) {
        onboardingManager.set(sequenceOfHabitFormation: sequenceOfHabitFormation)
    }
}
