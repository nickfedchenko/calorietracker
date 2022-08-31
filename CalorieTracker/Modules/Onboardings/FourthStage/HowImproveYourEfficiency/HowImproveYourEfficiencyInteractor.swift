//
//  HowImproveYourEfficiencyInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol HowImproveYourEfficiencyInteractorInterface: AnyObject {
    func getAllHowImproveYourEfficiency() -> [HowImproveYourEfficiency]
    func set(howImproveYourEfficiency: HowImproveYourEfficiency)
}

class HowImproveYourEfficiencyInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: HowImproveYourEfficiencyPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - HowImproveYourEfficiencyInteractorInterface

extension HowImproveYourEfficiencyInteractor: HowImproveYourEfficiencyInteractorInterface {
    func getAllHowImproveYourEfficiency() -> [HowImproveYourEfficiency] {
        return onboardingManager.getAllHowImproveYourEfficiency()
    }
    
    func set(howImproveYourEfficiency: HowImproveYourEfficiency) {
        onboardingManager.set(howImproveYourEfficiency: howImproveYourEfficiency)
    }
}
