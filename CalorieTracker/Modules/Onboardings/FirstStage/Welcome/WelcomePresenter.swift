//
//  WelcomePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation

protocol WelcomePresenterInterface: AnyObject {
    func didTapWelcomCommonButton()
}

class WelcomePresenter {
    
    // MARK: - Public properties

    unowned var view: WelcomeViewControllerInterface
    let router: WelcomeRouterInterface?
    let interactor: WelcomeInterctorInterface?

    // MARK: - Initialization
    
    init(
        interactor: WelcomeInterctorInterface,
        router: WelcomeRouterInterface,
        view: WelcomeViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - WelcomePresenterInterface

extension WelcomePresenter: WelcomePresenterInterface {
    func didTapWelcomCommonButton() {
        router?.openQuestionOfLosingWeight()
    }
}
