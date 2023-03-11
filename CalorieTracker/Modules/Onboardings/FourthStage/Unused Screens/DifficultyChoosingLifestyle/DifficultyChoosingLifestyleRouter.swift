//
//  DifficultyChoosingLifestyleRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import UIKit
//
//protocol DifficultyChoosingLifestyleRouterInterface: AnyObject {
//    func openInterestInUsingTechnology()
//}
//
//class DifficultyChoosingLifestyleRouter {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: DifficultyChoosingLifestylePresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> DifficultyChoosingLifestyleViewController {
//        let vc = DifficultyChoosingLifestyleViewController()
//        let interactor = DifficultyChoosingLifestyleInteractor(
//            onboardingManager: OnboardingManager.shared
//        )
//        let router = DifficultyChoosingLifestyleRouter()
//        let presenter = DifficultyChoosingLifestylePresenter(
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
//// MARK: - DifficultyChoosingLifestyleRouterInterface
//
//extension DifficultyChoosingLifestyleRouter: DifficultyChoosingLifestyleRouterInterface {
//    func openInterestInUsingTechnology() {
//        let interestInUsingTechnologyRouter = InterestInUsingTechnologyRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(
//            interestInUsingTechnologyRouter,
//            animated: true
//        )
//    }
//}
