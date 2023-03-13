//
//  YoureNotAloneRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import UIKit
//
//protocol YoureNotAloneRouterInterface: AnyObject {
//    func openDifficultyChoosingLifestyle()
//}
//
//class YoureNotAloneRouter {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: YoureNotAlonePresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> YoureNotAloneViewController {
//        let vc = YoureNotAloneViewController()
//        let interactor = YoureNotAloneInteractor(onboardingManager: OnboardingManager.shared)
//        let router = YoureNotAloneRouter()
//        let presenter = YoureNotAlonePresenter(
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
//// MARK: - YoureNotAloneRouterInterface
//
//extension YoureNotAloneRouter: YoureNotAloneRouterInterface {
//    func openDifficultyChoosingLifestyle() {
//        let difficultyChoosingLifestyleRouter = DifficultyChoosingLifestyleRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(
//            difficultyChoosingLifestyleRouter,
//            animated: true
//        )
//    }
//}
