//
//  RepresentationOfIncreasedActivityLevelsRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import UIKit
//
//protocol RepresentationOfIncreasedActivityLevelsRouterInterface: AnyObject {
//    func openSequenceOfHabitFormation()
//}
//
//class RepresentationOfIncreasedActivityLevelsRouter {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: RepresentationOfIncreasedActivityLevelsPresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> RepresentationOfIncreasedActivityLevelsViewController {
//        let vc = RepresentationOfIncreasedActivityLevelsViewController()
//        let interactor = RepresentationOfIncreasedActivityLevelsInteractor(
//            onboardingManager: OnboardingManager.shared
//        )
//        let router = RepresentationOfIncreasedActivityLevelsRouter()
//        let presenter = RepresentationOfIncreasedActivityLevelsPresenter(
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
//// MARK: - RepresentationOfIncreasedActivityLevelsRouterInterface
//
//extension RepresentationOfIncreasedActivityLevelsRouter: RepresentationOfIncreasedActivityLevelsRouterInterface {
//    func openSequenceOfHabitFormation() {
//        let sequenceOfHabitFormationRouter = SequenceOfHabitFormationRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(
//            sequenceOfHabitFormationRouter,
//            animated: true
//        )
//    }
//}
