//
//  TheEffectOfWeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol TheEffectOfWeightInteractorInterface: AnyObject {
    func getAllTheEffectOfWeight() -> [TheEffectOfWeight]
    func set(theEffectOfWeight: TheEffectOfWeight)
}

class TheEffectOfWeightInteractor {
    weak var presenter: TheEffectOfWeightPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

extension TheEffectOfWeightInteractor: TheEffectOfWeightInteractorInterface {
    func getAllTheEffectOfWeight() -> [TheEffectOfWeight] {
        return onboardingManager.getAllTheEffectOfWeight()
    }
    
    func set(theEffectOfWeight: TheEffectOfWeight) {
        onboardingManager.set(theEffectOfWeight: theEffectOfWeight)
    }
}
