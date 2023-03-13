//
//  TimeForYourselfRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

//import UIKit
//
//protocol TimeForYourselfRouterInterface: AnyObject {
//    func openJointWeightLoss()
//}
//
//class TimeForYourselfRouter {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: TimeForYourselfPresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> TimeForYourselfViewController {
//        let vc = TimeForYourselfViewController()
//        let interactor = TimeForYourselfInteractor(onboardingManager: OnboardingManager.shared)
//        let router = TimeForYourselfRouter()
//        let presenter = TimeForYourselfPresenter(
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
//// MARK: - TimeForYourselfRouterInterface
//
//extension TimeForYourselfRouter: TimeForYourselfRouterInterface {
//    func openJointWeightLoss() {
//        let jointWeightLossRouter = JointWeightLossRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(
//            jointWeightLossRouter,
//            animated: true
//        )
//    }
//}
