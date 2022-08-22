//
//  GetStartedPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation

protocol GetStartedPresenterInterface: AnyObject {
    func didTapGetStartedCommonButton()
}

class GetStartedPresenter {
    
    unowned var view: GetStartedViewControllerInterface
    let router: GetStartedRouterInterface?
    let interactor: GetStartedInteractorInterface?

    init(
        interactor: GetStartedInteractorInterface,
        router: GetStartedRouterInterface,
        view: GetStartedViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension GetStartedPresenter: GetStartedPresenterInterface {
    func didTapGetStartedCommonButton() {
        router?.openWelcome()
    }
}
