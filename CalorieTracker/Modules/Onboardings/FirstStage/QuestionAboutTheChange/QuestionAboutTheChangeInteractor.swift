//
//  QuestionAboutTheChangeInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol QuestionAboutTheChangeInteractorInterface: AnyObject {
    func getAllQuestionAboutTheChange() -> [QuestionAboutTheChange]
    func set(questionAboutTheChange: QuestionAboutTheChange)
}

class QuestionAboutTheChangeInteractor {
    
    // MARK: - Public properties
    
    weak var presenter: QuestionAboutTheChangePresenterInterface?
    
    // MARK: - Managers
    
    private let onboardingManager: OnboardingManagerInterface
    
    // MARK: - Initialization
    
    init(onboardingManager: OnboardingManagerInterface) {
        self.onboardingManager = onboardingManager
    }
}

// MARK: - QuestionAboutTheChangeInteractorInterface

extension QuestionAboutTheChangeInteractor: QuestionAboutTheChangeInteractorInterface {
    func getAllQuestionAboutTheChange() -> [QuestionAboutTheChange] {
        return onboardingManager.getAllQuestionAboutTheChange()
    }
    
    func set(questionAboutTheChange: QuestionAboutTheChange) {
        onboardingManager.set(questionAboutTheChange: questionAboutTheChange)
    }
}
