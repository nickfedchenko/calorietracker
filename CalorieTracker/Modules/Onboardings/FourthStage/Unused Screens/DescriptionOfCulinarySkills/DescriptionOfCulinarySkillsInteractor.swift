//
//  DescriptionOfCulinarySkillsInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import Foundation
//
//protocol DescriptionOfCulinarySkillsInteractorInterface: AnyObject {
//    func getAllDescriptionOfCulinarySkills() -> [DescriptionOfCulinarySkills]
//    func set(descriptionOfCulinarySkills: DescriptionOfCulinarySkills)
//    func getCurrentOnboardingStage() -> OnboardingStage
//}
//
//class DescriptionOfCulinarySkillsInteractor {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: DescriptionOfCulinarySkillsPresenterInterface?
//    
//    // MARK: - Managers
//    
//    private let onboardingManager: OnboardingManagerInterface
//    
//    // MARK: - Initialization
//    
//    init(onboardingManager: OnboardingManagerInterface) {
//        self.onboardingManager = onboardingManager
//    }
//}
//
//// MARK: - DescriptionOfCulinarySkillsInteractorInterface
//
//extension DescriptionOfCulinarySkillsInteractor: DescriptionOfCulinarySkillsInteractorInterface {
//    func getCurrentOnboardingStage() -> OnboardingStage {
//        return onboardingManager.getCurrentOnboardingStage()
//    }
//    
//    func getAllDescriptionOfCulinarySkills() -> [DescriptionOfCulinarySkills] {
//        return onboardingManager.getAllDescriptionOfCulinarySkills()
//    }
//    
//    func set(descriptionOfCulinarySkills: DescriptionOfCulinarySkills) {
//        onboardingManager.set(descriptionOfCulinarySkills: descriptionOfCulinarySkills)
//    }
//}
