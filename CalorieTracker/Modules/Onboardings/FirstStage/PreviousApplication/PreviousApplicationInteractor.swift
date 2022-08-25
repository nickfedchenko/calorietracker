//
//  PreviousApplicationInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol PreviousApplicationInteractorInterface: AnyObject {
    func getAllPreviousApplication() -> [PreviousApplication]
    func set(previousApplication: PreviousApplication)
}

class PreviousApplicationInteractor {
    
    // MARK: - Public properties

    weak var presenter: PreviousApplicationPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - PreviousApplicationInteractorInterface

extension PreviousApplicationInteractor: PreviousApplicationInteractorInterface {
    func getAllPreviousApplication() -> [PreviousApplication] {
        return onboardingManager.getAllPreviousApplication()
    }
    
    func set(previousApplication: PreviousApplication) {
        onboardingManager.set(previousApplication: previousApplication)
    }
}
