//
//  HowImproveYourEfficiencyRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import UIKit
//
//protocol HowImproveYourEfficiencyRouterInterface: AnyObject {
//    func openRepresentationOfIncreasedActivityLevels()
//}
//
//class HowImproveYourEfficiencyRouter {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: HowImproveYourEfficiencyPresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> HowImproveYourEfficiencyViewController {
//        let vc = HowImproveYourEfficiencyViewController()
//        let interactor = HowImproveYourEfficiencyInteractor(
//            onboardingManager: OnboardingManager.shared
//        )
//        let router = HowImproveYourEfficiencyRouter()
//        let presenter = HowImproveYourEfficiencyPresenter(
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
//// MARK: - HowImproveYourEfficiencyRouterInterface
//
//extension HowImproveYourEfficiencyRouter: HowImproveYourEfficiencyRouterInterface {
//    func openRepresentationOfIncreasedActivityLevels() {
//        let representationOfIncreasedActivityLevelsRouter = RepresentationOfIncreasedActivityLevelsRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(
//            representationOfIncreasedActivityLevelsRouter,
//            animated: true
//        )
//    }
//}
