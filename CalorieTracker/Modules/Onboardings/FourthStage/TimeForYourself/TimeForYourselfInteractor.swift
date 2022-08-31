//
//  TimeForYourselfInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation

protocol TimeForYourselfInteractorInterface: AnyObject {
    func getAllTimeForYourself() -> [TimeForYourself]
    func set(timeForYourself: TimeForYourself)
}

class TimeForYourselfInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: TimeForYourselfPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - TimeForYourselfInteractorInterface

extension TimeForYourselfInteractor: TimeForYourselfInteractorInterface {
    func getAllTimeForYourself() -> [TimeForYourself] {
        return onboardingManager.getAllTimeForYourself()
    }
    
    func set(timeForYourself: TimeForYourself) {
        onboardingManager.set(timeForYourself: timeForYourself)
    }
}
