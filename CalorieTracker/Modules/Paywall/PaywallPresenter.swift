//
//  PaywallPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import Foundation

protocol PaywallPresenterInterface: AnyObject {
    func didTapStartNow()
    func didTapCancelAnytime()
    func didTapPrivacyPolicy()
    func didTapTermOfUse()
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
    func didTapStartNow() {}
    
    func didTapCancelAnytime() {}
    
    func didTapPrivacyPolicy() {}
    
    func didTapTermOfUse() {}
}
