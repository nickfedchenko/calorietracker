//
//  QuestionOfLosingWeightInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation

protocol QuestionOfLosingWeightInteractorInterface: AnyObject {
    func set(isHaveYouTriedToLoseWeightBefor: Bool)
}

class QuestionOfLosingWeightInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: QuestionOfLosingWeightPresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - QuestionOfLosingWeightInteractorInterface

extension QuestionOfLosingWeightInteractor: QuestionOfLosingWeightInteractorInterface {
    func set(isHaveYouTriedToLoseWeightBefor: Bool) {
        onboardingManager.set(isHaveYouTriedToLoseWeightBefor: isHaveYouTriedToLoseWeightBefor)
    }
}
