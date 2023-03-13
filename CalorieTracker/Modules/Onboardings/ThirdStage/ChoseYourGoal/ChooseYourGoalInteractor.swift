//
//  ChooseYourGoalInteractor.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 11.03.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Foundation

protocol ChooseYourGoalInteractorInterface: AnyObject {
    func getAllChooseYourGoal() -> [ChooseYourGoal]
    func set(chooseYourGoal: ChooseYourGoal)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class ChooseYourGoalInteractor {
    weak var presenter: ChooseYourGoalPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

extension ChooseYourGoalInteractor: ChooseYourGoalInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllChooseYourGoal() -> [ChooseYourGoal] {
        return onboardingManager.getAllChooseYourGoal()
    }
    
    func set(chooseYourGoal: ChooseYourGoal) {
        onboardingManager.set(chooseYourGoal: chooseYourGoal)
    }
}
