//
//  EnvironmentInfluencesTheChoiceInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol EnvironmentInfluencesTheChoiceInteractorInterface: AnyObject {
    func getAllEnvironmentInfluencesTheChoice() -> [EnvironmentInfluencesTheChoice]
    func set(environmentInfluencesTheChoice: EnvironmentInfluencesTheChoice)
}

class EnvironmentInfluencesTheChoiceInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: EnvironmentInfluencesTheChoicePresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

extension EnvironmentInfluencesTheChoiceInteractor: EnvironmentInfluencesTheChoiceInteractorInterface {
    func getAllEnvironmentInfluencesTheChoice() -> [EnvironmentInfluencesTheChoice] {
        return onboardingManager.getAllEnvironmentInfluencesTheChoice()
    }
    
    func set(environmentInfluencesTheChoice: EnvironmentInfluencesTheChoice) {
        onboardingManager.set(environmentInfluencesTheChoice: environmentInfluencesTheChoice)
    }
}
