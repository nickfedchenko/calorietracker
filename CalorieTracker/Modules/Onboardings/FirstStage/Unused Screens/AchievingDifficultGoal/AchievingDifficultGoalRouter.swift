//
//  AchievingDifficultGoalRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//
//
//import Foundation
//import UIKit
//
//protocol AchievingDifficultGoalRouterInterface: AnyObject {
//    func openAchievementByWillpower()
//}
//
//class AchievingDifficultGoalRouter: NSObject {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: AchievingDifficultGoalPresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> AchievingDifficultGoalViewController {
//        let vc = AchievingDifficultGoalViewController()
//        let interactor = AchievingDifficultGoalInteractor(
//            onboardingManager: OnboardingManager.shared)
//        let router = AchievingDifficultGoalRouter()
//        let presenter = AchievingDifficultGoalPresenter(
//            interactor: interactor,
//            router: router,
//            view: vc
//        )
//
//        vc.presenter = presenter
//        router.presenter = presenter
//        router.viewController = vc
//        interactor.presenter = presenter
//        return vc
//    }
//}
//
//// MARK: - AchievingDifficultGoalRouterInterface
//
//extension AchievingDifficultGoalRouter: AchievingDifficultGoalRouterInterface {
//    func openAchievementByWillpower() {
//        let achievementByWillPowerRouter = AchievementByWillPowerRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(achievementByWillPowerRouter, animated: true)
//    }
//}
