//
//  JointWeightLossInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

//import Foundation
//
//protocol JointWeightLossInteractorInterface: AnyObject {
//    func getAllJointWeightLoss() -> [JointWeightLoss]
//    func set(jointWeightLoss: JointWeightLoss)
//    func getCurrentOnboardingStage() -> OnboardingStage
//}
//
//class JointWeightLossInteractor {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: JointWeightLossPresenterInterface?
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
//// MARK: - JointWeightLossInteractorInterface
//
//extension JointWeightLossInteractor: JointWeightLossInteractorInterface {
//    func getCurrentOnboardingStage() -> OnboardingStage {
//        return onboardingManager.getCurrentOnboardingStage()
//    }
//    
//    func getAllJointWeightLoss() -> [JointWeightLoss] {
//        return onboardingManager.getAllJointWeightLoss()
//    }
//    
//    func set(jointWeightLoss: JointWeightLoss) {
//        onboardingManager.set(jointWeightLoss: jointWeightLoss)
//    }
//}
