//
//  RateUsScreenRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 10.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import ApphudSDK
import StoreKit
import UIKit

protocol RateUsScreenRouterInterface: AnyObject {
    func didTapNextButton()
}

class RateUsScreenRouter: NSObject {

    weak var presenter: RateUsScreenPresenterInterface?
    weak var viewController: UIViewController?
    
    private var didShowReviewRequest: Bool = false
    
    static func setupModule() -> RateUsScreenViewController {
        let vc = RateUsScreenViewController()
        let interactor = RateUsScreenInteractor()
        let router = RateUsScreenRouter()
        let presenter = RateUsScreenPresenter(interactor: interactor, router: router, view: vc)

        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension RateUsScreenRouter: RateUsScreenRouterInterface {
    func didTapNextButton() {
        if didShowReviewRequest {
            if Apphud.hasActiveSubscription() {
                let vc = CTTabBarController()
                if let navigationController = viewController?.navigationController {
                    vc.navigationController?.isNavigationBarHidden = true
                    navigationController.setViewControllers([vc], animated: true)
                    UIView.transition(
                        with: navigationController.view,
                        duration: 0.3,
                        options: [.transitionCrossDissolve],
                        animations: nil
                    )
                } else {
                    viewController?.dismiss(animated: true)
                }
            } else {
                let paywall = PaywallRouter.setupModule()
                viewController?.navigationController?.pushViewController(paywall, animated: true)
            }
            _ = OnboardingSaveDataService(OnboardingManager.shared.getOnboardingInfo())
        } else {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                let paywall = PaywallRouter.setupModule()
                viewController?.navigationController?.pushViewController(paywall, animated: true)
                return
            }
             
             SKStoreReviewController.requestReview(in: scene)
            didShowReviewRequest.toggle()
        }
      
    }
}
