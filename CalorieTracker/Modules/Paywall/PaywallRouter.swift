//
//  PaywallRouter.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import UIKit

protocol PaywallRouterInterface: AnyObject {
    func navigateToApp()
    func showAlert()
    func openTerms()
    func openPolicy()
}

class PaywallRouter {
    
    // MARK: - Public properties
    
    weak var presenter: PaywallPresenterInterface?
    weak var viewController: UIViewController?
    
    // MARK: - Static methods
    
    static func setupModule() -> PaywallViewController {
        let vc = PaywallViewController()
        let interactor = PaywallInteractor()
        let router = PaywallRouter()
        let viewModel = SubscriptionViewModel()
        let presenter = PaywallPresenter(
            interactor: interactor,
            router: router,
            view: vc
        )

        vc.subscriptionViewModel = viewModel
        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

// MARK: - PaywallRouterInterface

extension PaywallRouter: PaywallRouterInterface {
    func navigateToApp() {
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
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Performing purchase",
            preferredStyle: .alert
        )
        
        alert.addAction(.init(
            title: R.string.localizable.cancel().capitalized,
            style: .cancel
        ))
        
        viewController?.present(alert, animated: true)
    }
    
    func openTerms() {
        viewController?.openSafaryUrl(
            "https://docs.google.com/document/d/1JcCmpl__MudDKQhdrCwT30HRXID2ZoFJL3Ux4ooR-jk/edit?usp=sharing"
        )
    }
    
    func openPolicy() {
        viewController?.openSafaryUrl(
            "https://docs.google.com/document/d/1PL9dbxBszn3_2srCTsclI9zISGiUHUDTkp8v2YfFc7s/edit?usp=sharing"
        )
    }
}
