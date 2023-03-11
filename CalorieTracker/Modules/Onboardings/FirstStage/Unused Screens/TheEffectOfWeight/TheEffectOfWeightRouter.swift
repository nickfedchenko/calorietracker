//
//  TheEffectOfWeightRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

//import Foundation
//import UIKit
//
//protocol TheEffectOfWeightRouterInterface: AnyObject {
//    func openFormationGoodHabits()
//}
//
//class TheEffectOfWeightRouter: NSObject {
//    
//    // MARK: - Public properties
//
//    weak var presenter: TheEffectOfWeightPresenterInterface?
//    weak var viewController: UIViewController?
//    
//    static func setupModule() -> TheEffectOfWeightViewController {
//        let vc = TheEffectOfWeightViewController()
//        let interactor = TheEffectOfWeightInteractor(onboardingManager: OnboardingManager.shared)
//        let router = TheEffectOfWeightRouter()
//        let presenter = TheEffectOfWeightPresenter(
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
//// MARK: - ObsessingOverFoodRouterInterface
//
//extension TheEffectOfWeightRouter: TheEffectOfWeightRouterInterface {
//    func openFormationGoodHabits() {
//        let formationGoodHabitsRouter = FormationGoodHabitsRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(formationGoodHabitsRouter, animated: true)
//    }
//}
