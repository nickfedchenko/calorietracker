//
//  HelpingPeopleTrackCaloriesInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import Foundation
//
//protocol HelpingPeopleTrackCaloriesInteractorInterface: AnyObject {
//    func getCurrentOnboardingStage() -> OnboardingStage
//}
//
//class HelpingPeopleTrackCaloriesInteractor {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: HelpingPeopleTrackCaloriesPresenterInterface?
//    
//    // MARK: - Managers
//    
//    private let onboardingManager: OnboardingManagerInterface
//    
//    // MARK: - Initialization
//    
//    init(onboardingManager: OnboardingManagerInterface) {
//        self.onboardingManager = onboardingManager
//        
//    }
//}
//
//// MARK: - HelpingPeopleTrackCaloriesInteractorInterface
//
//extension HelpingPeopleTrackCaloriesInteractor: HelpingPeopleTrackCaloriesInteractorInterface {
//    func getCurrentOnboardingStage() -> OnboardingStage {
//        return onboardingManager.getCurrentOnboardingStage()
//    }
//}
