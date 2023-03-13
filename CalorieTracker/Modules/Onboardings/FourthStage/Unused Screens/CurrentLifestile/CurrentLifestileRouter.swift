//
//  CurrentLifestileRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

//import UIKit
//
//protocol CurrentLifestileRouterInterface: AnyObject {
//    func openImprovingNutrition()
//}
//
//class CurrentLifestileRouter {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: CurrentLifestilePresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> CurrentLifestileViewController {
//        let vc = CurrentLifestileViewController()
//        let interactor = CurrentLifestileInteractor(onboardingManager: OnboardingManager.shared)
//        let router = CurrentLifestileRouter()
//        let presenter = CurrentLifestilePresenter(
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
//// MARK: - CurrentLifestileRouterInterface
//
//extension CurrentLifestileRouter: CurrentLifestileRouterInterface {
//    func openImprovingNutrition() {
//        let improvingNutritionRouter = ImprovingNutritionRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(improvingNutritionRouter, animated: true)
//    }
//}
