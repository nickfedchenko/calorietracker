//
//  ImportanceOfWeightLossInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation

protocol ImportanceOfWeightLossInteractorInterface: AnyObject {
    func getAllImportanceOfWeightLoss() -> [ImportanceOfWeightLoss]
    func set(importanceOfWeightLoss: ImportanceOfWeightLoss)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class ImportanceOfWeightLossInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: ImportanceOfWeightLossPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - ImportanceOfWeightLossInteractorInterface

extension ImportanceOfWeightLossInteractor: ImportanceOfWeightLossInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllImportanceOfWeightLoss() -> [ImportanceOfWeightLoss] {
        return onboardingManager.getAllImportanceOfWeightLoss()
    }
    
    func set(importanceOfWeightLoss: ImportanceOfWeightLoss) {
        onboardingManager.set(importanceOfWeightLoss: importanceOfWeightLoss)
    }
}
