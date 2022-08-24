//
//  PurposeOfTheParishRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation
import Lottie
import UIKit

protocol PurposeOfTheParishRouterInterface: AnyObject {
    func openRecentWeightChanges()
}

class PurposeOfTheParishRouter: NSObject {
    
    weak var presenter: PurposeOfTheParishPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> PurposeOfTheParishViewController {
        let vc = PurposeOfTheParishViewController()
        let interactor = PurposeOfTheParishInteractor(
            onboardingManager: OnboardingManager.shared)
        let router = PurposeOfTheParishRouter()
        let presenter = PurposeOfTheParishPresenter(
            interactor: interactor,
            router: router,
            view: vc
        )

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension PurposeOfTheParishRouter: PurposeOfTheParishRouterInterface {
    func openRecentWeightChanges() {
        let recentWeightChangesRouter = RecentWeightChangesRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(recentWeightChangesRouter, animated: true)
    }
}
