//
//  DifficultyChoosingLifestyleInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import Foundation
//
//protocol DifficultyChoosingLifestyleInteractorInterface: AnyObject {
//    func getCurrentOnboardingStage() -> OnboardingStage
//    func set(difficultyChoosingLifestyle: Bool)
//}
//
//class DifficultyChoosingLifestyleInteractor {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: DifficultyChoosingLifestylePresenterInterface?
//    
//    // MARK: - Managers
//    
//    private let onboardingManager: OnboardingManagerInterface
//    
//    // MARK: - Initialization
//    
//    init(onboardingManager: OnboardingManagerInterface) {
//        self.onboardingManager = onboardingManager}
//}
//
//// MARK: - DifficultyChoosingLifestyleInteractorInterface
//
//extension DifficultyChoosingLifestyleInteractor: DifficultyChoosingLifestyleInteractorInterface {
//    func getCurrentOnboardingStage() -> OnboardingStage {
//        return onboardingManager.getCurrentOnboardingStage()
//    }
//    
//    func set(difficultyChoosingLifestyle: Bool) {
//        onboardingManager.set(difficultyChoosingLifestyle: difficultyChoosingLifestyle)
//    }
//}
