//
//  LoadingScreenRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 19.05.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import ApphudSDK
import Foundation
import UIKit

protocol LoadingScreenRouterInterface: AnyObject {
    func navigateToMainScreen()
}

class LoadingScreenRouter: NSObject {

    weak var presenter: LoadingScreenPresenterInterface?
    weak var viewController: UIViewController?

    static func setupModule() -> LoadingScreenViewController {
        let vc = LoadingScreenViewController()
        let interactor = LoadingScreenInteractor()
        let router = LoadingScreenRouter()
        let presenter = LoadingScreenPresenter(interactor: interactor, router: router, view: vc)
        interactor.loadingManager = IncrementalUpdateManager()
        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension LoadingScreenRouter: LoadingScreenRouterInterface {
    func navigateToMainScreen() {
        var startViewController: UIViewController
        if UDM.userData == nil {
            startViewController = WelcomeRouter.setupModule()
            //            getStartedViewController = ChooseDietaryPreferenceRouter.setupModule()
        } else {
            if Apphud.hasActiveSubscription() {
                startViewController = CTTabBarController()
            } else {
                startViewController = PaywallRouter.setupModule()
            }
        }
        
        if let navigationController = viewController?.navigationController {
            navigationController.setViewControllers([startViewController], animated: true)
            UIView.transition(
                with: navigationController.view,
                duration: 0.3,
                options: [.transitionCrossDissolve],
                animations: nil
            )
        }
    }
}
