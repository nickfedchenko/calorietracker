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
    func getAllImportanceOfWeightLoss() -> [ImportanceOfWeightLoss] {
        return onboardingManager.getAllImportanceOfWeightLoss()
    }
    
    func set(importanceOfWeightLoss: ImportanceOfWeightLoss) {
        onboardingManager.set(importanceOfWeightLoss: importanceOfWeightLoss)
    }
}

