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
}

class FormationGoodHabitsInteractor {
    weak var presenter: FormationGoodHabitsPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

extension FormationGoodHabitsInteractor: FormationGoodHabitsInteractorInterface {
    func getAllFormationGoodHabits() -> [FormationGoodHabits] {
        return onboardingManager.getAllFormationGoodHabits()
    }
    
    func set(formationGoodHabits: FormationGoodHabits) {
        onboardingManager.set(formationGoodHabits: formationGoodHabits)
    }
}
