//
//  DescriptionOfExperienceInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation

protocol DescriptionOfExperienceInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
    func getAllDescriptionOfExperience() -> [DescriptionOfExperience]
    func set(descriptionOfExperience: DescriptionOfExperience)
}

class DescriptionOfExperienceInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: DescriptionOfExperiencePresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - DescriptionOfExperienceInteractorInterface

extension DescriptionOfExperienceInteractor: DescriptionOfExperienceInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllDescriptionOfExperience() -> [DescriptionOfExperience] {
        return onboardingManager.getAllDescriptionOfExperience()
    }
    
    func set(descriptionOfExperience: DescriptionOfExperience) {
        onboardingManager.set(descriptionOfExperience: descriptionOfExperience)
    }
}
