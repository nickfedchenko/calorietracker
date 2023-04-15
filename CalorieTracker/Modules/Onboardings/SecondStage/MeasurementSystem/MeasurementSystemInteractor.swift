//
//  MeasurementSystemInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import Foundation

protocol MeasurementSystemInteractorInterface: AnyObject {
    func getAllMeasurementSystem() -> [MeasurementSystem]
    func set(measurementSystem: MeasurementSystem)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class MeasurementSystemInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: MeasurementSystemPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - MeasurementSystemInteractorInterface

extension MeasurementSystemInteractor: MeasurementSystemInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllMeasurementSystem() -> [MeasurementSystem] {
        return onboardingManager.getAllMeasurementSystem()
    }
    
    func set(measurementSystem: MeasurementSystem) {
        onboardingManager.set(measurementSystem: measurementSystem)
        if measurementSystem == .imperialSystem {
            UDM.lengthIsMetric = false
            UDM.weightIsMetric = false

        } else {
            UDM.lengthIsMetric = true
            UDM.weightIsMetric = true
        }
    }
}
 
