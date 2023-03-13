//
//  ActivityLevelSelectionRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 10.02.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation
import UIKit

protocol ActivityLevelSelectionRouterInterface: AnyObject {
    func openDeficitAndSurplusCalorie()
}

class ActivityLevelSelectionRouter: NSObject {

    weak var presenter: ActivityLevelSelectionPresenterInterface?
    private var viewController: UIViewController?
    static func setupModule() -> ActivityLevelSelectionViewController {
        let vc = ActivityLevelSelectionViewController()
        let interactor = ActivityLevelSelectionInteractor(onboardingManager: OnboardingManager.shared)
        let router = ActivityLevelSelectionRouter()
        let presenter = ActivityLevelSelectionPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension ActivityLevelSelectionRouter: ActivityLevelSelectionRouterInterface {
    func openDeficitAndSurplusCalorie() {
        let deficitAndSurplusCalorieRouter = DeficitAndSurplusCalorieRouter.setupModule()
        
        viewController?.navigationController?.pushViewController(deficitAndSurplusCalorieRouter, animated: true)
    }
}
