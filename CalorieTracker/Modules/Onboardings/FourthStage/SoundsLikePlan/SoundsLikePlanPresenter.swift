//
//  SoundsLikePlanPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol SoundsLikePlanPresenterInterface: AnyObject {
    func didTapContinueCommonButton()
}

class SoundsLikePlanPresenter {
    
    // MARK: - Public properties

    unowned var view: SoundsLikePlanViewControllerInterface
    let router: SoundsLikePlanRouterInterface?
    let interactor: SoundsLikePlanInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: SoundsLikePlanInteractorInterface,
        router: SoundsLikePlanRouterInterface,
        view: SoundsLikePlanViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - SoundsLikePlanPresenterInterface

extension SoundsLikePlanPresenter: SoundsLikePlanPresenterInterface {
    func didTapContinueCommonButton() {
        router?.openIncreasingYourActivityLevel()
    }
}
