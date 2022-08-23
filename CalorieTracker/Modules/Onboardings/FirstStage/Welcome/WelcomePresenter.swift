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
    
    unowned var view: WelcomeViewControllerInterface
    let router: WelcomeRouterInterface?
    let interactor: WelcomeInterctorInterface?

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

extension WelcomePresenter: WelcomePresenterInterface {
    func didTapWelcomCommonButton() {
        router?.openQuestionOfLosingWeight()
    }
}
