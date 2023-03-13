//
//  QuestionAboutTheChangeRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//
//
//import Foundation
//import UIKit
//
//protocol QuestionAboutTheChangeRouterInterface: AnyObject {
//    func openAchievingDifficultGoal()
//}
//
//class QuestionAboutTheChangeRouter: NSObject {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: QuestionAboutTheChangePresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> QuestionAboutTheChangeViewController {
//        let vc = QuestionAboutTheChangeViewController()
//        let interactor = QuestionAboutTheChangeInteractor(
//            onboardingManager: OnboardingManager.shared)
//        let router = QuestionAboutTheChangeRouter()
//        let presenter = QuestionAboutTheChangePresenter(
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
//// MARK: - QuestionAboutTheChangeRouterInterface
//
//extension QuestionAboutTheChangeRouter: QuestionAboutTheChangeRouterInterface {
//    func openAchievingDifficultGoal() {
//        let calorieCountRouter = CalorieCountRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(calorieCountRouter, animated: true)
//    }
//}
