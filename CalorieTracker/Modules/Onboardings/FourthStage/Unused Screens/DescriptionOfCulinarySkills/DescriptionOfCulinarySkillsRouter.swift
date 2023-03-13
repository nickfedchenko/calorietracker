//
//  DescriptionOfCulinarySkillsRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

//import UIKit
//
//protocol DescriptionOfCulinarySkillsRouterInterface: AnyObject {
//    func openWhatImportantToYou()
//}
//
//class DescriptionOfCulinarySkillsRouter {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: DescriptionOfCulinarySkillsPresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> DescriptionOfCulinarySkillsViewController {
//        let vc = DescriptionOfCulinarySkillsViewController()
//        let interactor = DescriptionOfCulinarySkillsInteractor(
//            onboardingManager: OnboardingManager.shared
//        )
//        let router = DescriptionOfCulinarySkillsRouter()
//        let presenter = DescriptionOfCulinarySkillsPresenter(
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
//// MARK: - DescriptionOfCulinarySkillsRouterInterface
//
//extension DescriptionOfCulinarySkillsRouter: DescriptionOfCulinarySkillsRouterInterface {
//    func openWhatImportantToYou() {
//        let whatImportantToYouRouter = WhatImportantToYouRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(
//            whatImportantToYouRouter,
//            animated: true
//        )
//    }
//}
