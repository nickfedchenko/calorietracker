//
//  RisksOfDiseasesInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation

protocol RisksOfDiseasesInteractorInterface: AnyObject {
    func getAllRisksOfDiseases() -> [RisksOfDiseases]
    func set(risksOfDiseases: RisksOfDiseases)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class RisksOfDiseasesInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: RisksOfDiseasesPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - RisksOfDiseasesInteractorInterface

extension RisksOfDiseasesInteractor: RisksOfDiseasesInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllRisksOfDiseases() -> [RisksOfDiseases] {
        return onboardingManager.getAllRisksOfDiseases()
    }
    
    func set(risksOfDiseases: RisksOfDiseases) {
        onboardingManager.set(risksOfDiseases: risksOfDiseases)
    }
}
