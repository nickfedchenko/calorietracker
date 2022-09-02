//
//  BestDescriptionOfTheSituationInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol BestDescriptionOfTheSituationInteractorInterface: AnyObject {
    func getAllBestDescriptionOfTheSituation() -> [BestDescriptionOfTheSituation]
    func set(bestDescriptionOfTheSituation: BestDescriptionOfTheSituation)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class BestDescriptionOfTheSituationInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: BestDescriptionOfTheSituationPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - BestDescriptionOfTheSituationInteractorInterface

extension BestDescriptionOfTheSituationInteractor: BestDescriptionOfTheSituationInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllBestDescriptionOfTheSituation() -> [BestDescriptionOfTheSituation] {
        return onboardingManager.getAllBestDescriptionOfTheSituation()
    }
    
    func set(bestDescriptionOfTheSituation: BestDescriptionOfTheSituation) {
        onboardingManager.set(bestDescriptionOfTheSituation: bestDescriptionOfTheSituation)
    }
}
