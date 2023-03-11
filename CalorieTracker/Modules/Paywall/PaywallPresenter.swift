//
//  PaywallPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import ApphudSDK
import Foundation

protocol PaywallPresenterInterface: AnyObject {
    func didTapPrivacyPolicy()
    func didTapTermOfUse()
    func productPurchase(_ product: ApphudProduct)
    func continueToAppNonConditionally()
    func didTapCloseButton()
}

class PaywallPresenter {
    
    // MARK: - Public properties

    unowned var view: PaywallViewControllerInterface
    let router: PaywallRouterInterface?
    let interactor: PaywallInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: PaywallInteractorInterface,
        router: PaywallRouterInterface,
        view: PaywallViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - PaywallPresenterInterface

extension PaywallPresenter: PaywallPresenterInterface {
    func didTapCloseButton() {
        router?.navigateToApp()
    }
    
    func didTapPrivacyPolicy() {
        router?.openPolicy()
    }
    
    func didTapTermOfUse() {
        router?.openTerms()
    }
    
    func productPurchase(_ product: ApphudProduct) {
        Apphud.purchase(product) { [weak self] result in
            guard result.error == nil else {
                self?.router?.showAlert()
                return
            }
            
            if let subscription = result.subscription, subscription.isActive() {
                self?.router?.navigateToApp()
            } else if let purchase = result.nonRenewingPurchase, purchase.isActive() {
                self?.router?.navigateToApp()
            } else {
                if Apphud.hasActiveSubscription() {
                    self?.router?.navigateToApp()
                }
            }
        }
    }
    
    func continueToAppNonConditionally() {
        router?.navigateToApp()
    }
}
