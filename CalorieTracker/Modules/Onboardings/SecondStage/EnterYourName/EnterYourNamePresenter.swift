//
//  EnterYourNamePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 25.08.2022.
//

import Foundation

protocol EnterYourNamePresenterInterface: AnyObject {
    func didTapContinueCommonButton(with name: String)
}

class EnterYourNamePresenter {
    
    // MARK: - Public properties

    unowned var view: EnterYourNameViewControllerInterface
    let router: EnterYourNameRouterInterface?
    let interactor: EnterYourNameInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: EnterYourNameInteractorInterface,
        router: EnterYourNameRouterInterface,
        view: EnterYourNameViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - WelcomePresenterInterface

extension EnterYourNamePresenter: EnterYourNamePresenterInterface {
    func didTapContinueCommonButton(with name: String) {
        interactor?.set(enterYourName: name)
        router?.openWhatsYourGender()
    }
}
