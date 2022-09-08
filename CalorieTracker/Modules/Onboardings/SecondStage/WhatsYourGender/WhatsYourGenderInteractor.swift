//
//  WhatsYourGenderInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 25.08.2022.
//

import Foundation

protocol WhatsYourGenderInteractorInterface: AnyObject {
    func getAllWhatsYourGender() -> [WhatsYourGender]
    func set(whatsYourGender: WhatsYourGender)
    func getCurrentOnboardingStage() -> OnboardingStage
}

class WhatsYourGenderInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: WhatsYourGenderPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - WhatsYourGenderInteractorInterface

extension WhatsYourGenderInteractor: WhatsYourGenderInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func getAllWhatsYourGender() -> [WhatsYourGender] {
        return onboardingManager.getAllWhatsYourGender()
    }
    
    func set(whatsYourGender: WhatsYourGender) {
        onboardingManager.set(whatsYourGender: whatsYourGender)
    }
}
