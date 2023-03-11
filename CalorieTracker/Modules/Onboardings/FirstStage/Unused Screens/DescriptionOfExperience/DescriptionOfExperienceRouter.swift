//
//  DescriptionOfExperienceRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//
//
//import Foundation
//import UIKit
//
//protocol DescriptionOfExperienceRouterInterface: AnyObject {
//    func openPurposeOfTheParish()
//}
//
//class DescriptionOfExperienceRouter: NSObject {
//    
//    // MARK: - Public properties
//    
//    weak var presenter: DescriptionOfExperiencePresenterInterface?
//    weak var viewController: UIViewController?
//    
//    // MARK: - Static methods
//    
//    static func setupModule() -> DescriptionOfExperienceViewController {
//        let vc = DescriptionOfExperienceViewController()
//        let interactor = DescriptionOfExperienceInteractor(
//            onboardingManager: OnboardingManager.shared
//        )
//        let router = DescriptionOfExperienceRouter()
//        let presenter = DescriptionOfExperiencePresenter(
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
//// MARK: - DescriptionOfExperienceRouterInterface
//
//extension DescriptionOfExperienceRouter: DescriptionOfExperienceRouterInterface {
//    func openPurposeOfTheParish() {
//        let purposeOfTheParishRouter = PurposeOfTheParishRouter.setupModule()
//        
//        viewController?.navigationController?.pushViewController(purposeOfTheParishRouter, animated: true)
//    }
//}
