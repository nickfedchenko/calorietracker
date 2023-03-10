//
//  ChooseDietaryPreferenceInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 02.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

protocol ChooseDietaryPreferenceInteractorInterface: AnyObject {
    func getCurrentOnboardingStage() -> OnboardingStage
    func setSelectedDietary(dietary: UserDietary)
}

class ChooseDietaryPreferenceInteractor {
    weak var presenter: ChooseDietaryPreferencePresenterInterface?
    private let onboardingManager: OnboardingManagerInterface
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

extension ChooseDietaryPreferenceInteractor: ChooseDietaryPreferenceInteractorInterface {
    func getCurrentOnboardingStage() -> OnboardingStage {
        return onboardingManager.getCurrentOnboardingStage()
    }
    
    func setSelectedDietary(dietary: UserDietary) {
        onboardingManager.setDietary(dietary: dietary)
    }
}
