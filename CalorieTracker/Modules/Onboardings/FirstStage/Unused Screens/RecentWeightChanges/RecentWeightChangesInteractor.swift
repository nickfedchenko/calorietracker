//
//  RecentWeightChangesInteractor.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

//import Foundation
//
//protocol RecentWeightChangesInteractorInterface: AnyObject {
//    func getCurrentOnboardingStage() -> OnboardingStage
//    func set(recentWeightChanges: Bool)
//}
//
//class RecentWeightChangesInteractor {
//
//    // MARK: - Public properties
//
//    weak var presenter: RecentWeightChangesPresenterInterface?
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
//// MARK: - RecentWeightChangesInteractorInterface
//
//extension RecentWeightChangesInteractor: RecentWeightChangesInteractorInterface {
//    func getCurrentOnboardingStage() -> OnboardingStage {
//        return onboardingManager.getCurrentOnboardingStage()
//    }
//
//    func set(recentWeightChanges: Bool) {
//        onboardingManager.set(recentWeightChanges: recentWeightChanges)
//    }
//}
