//
//  SequenceOfHabitFormationRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import UIKit
//
//protocol SequenceOfHabitFormationRouterInterface: AnyObject {
//    func openSoundsGood()
//}
//
//class SequenceOfHabitFormationRouter {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: SequenceOfHabitFormationPresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> SequenceOfHabitFormationViewController {
//        let vc = SequenceOfHabitFormationViewController()
//        let interactor = SequenceOfHabitFormationInteractor(
//            onboardingManager: OnboardingManager.shared
//        )
//        let router = SequenceOfHabitFormationRouter()
//        let presenter = SequenceOfHabitFormationPresenter(
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
//// MARK: - SequenceOfHabitFormationRouterInterface
//
//extension SequenceOfHabitFormationRouter: SequenceOfHabitFormationRouterInterface {
//    func openSoundsGood() {
//        let dieatryChoose = ChooseDietaryPreferenceRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(
//            dieatryChoose,
//            animated: true
//        )
//    }
//}
