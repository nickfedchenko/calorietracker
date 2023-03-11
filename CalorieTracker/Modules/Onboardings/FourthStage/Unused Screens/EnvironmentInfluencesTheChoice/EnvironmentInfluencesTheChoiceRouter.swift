//
//  EnvironmentInfluencesTheChoiceRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

//import UIKit
//
//protocol EnvironmentInfluencesTheChoiceRouterInterface: AnyObject {
//    func openBestDescriptionOfTheSituation()
//}
//
//class EnvironmentInfluencesTheChoiceRouter {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: EnvironmentInfluencesTheChoicePresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> EnvironmentInfluencesTheChoiceViewController {
//        let vc = EnvironmentInfluencesTheChoiceViewController()
//        let interactor = EnvironmentInfluencesTheChoiceInteractor(onboardingManager: OnboardingManager.shared)
//        let router = EnvironmentInfluencesTheChoiceRouter()
//        let presenter = EnvironmentInfluencesTheChoicePresenter(
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
//// MARK: - EnvironmentInfluencesTheChoiceRouterInterface
//
//extension EnvironmentInfluencesTheChoiceRouter: EnvironmentInfluencesTheChoiceRouterInterface {
//    func openBestDescriptionOfTheSituation() {
//        let bestDescriptionOfTheSituationRouter = BestDescriptionOfTheSituationRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(
//            bestDescriptionOfTheSituationRouter,
//            animated: true
//        )
//    }
//}
