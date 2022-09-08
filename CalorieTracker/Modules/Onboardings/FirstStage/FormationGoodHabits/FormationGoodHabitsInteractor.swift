//
//  FormationGoodHabitsInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol FormationGoodHabitsInteractorInterface: AnyObject {
    func getAllFormationGoodHabits() -> [FormationGoodHabits]
    func set(formationGoodHabits: FormationGoodHabits)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class FormationGoodHabitsInteractor {
    
    // MARK: - Public properties

    weak var presenter: FormationGoodHabitsPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - FormationGoodHabitsInteractorInterface

extension FormationGoodHabitsInteractor: FormationGoodHabitsInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllFormationGoodHabits() -> [FormationGoodHabits] {
        return onboardingManager.getAllFormationGoodHabits()
    }
    
    func set(formationGoodHabits: FormationGoodHabits) {
        onboardingManager.set(formationGoodHabits: formationGoodHabits)
    }
}
