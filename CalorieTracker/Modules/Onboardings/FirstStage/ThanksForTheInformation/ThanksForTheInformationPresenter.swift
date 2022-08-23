//
//  ThanksForTheInformationPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ThanksForTheInformationPresenterInterface: AnyObject {
    func didTapContinueCommonButton()
}

class ThanksForTheInformationPresenter {
    
    unowned var view: ThanksForTheInformationViewControllerInterface
    let router: ThanksForTheInformationRouterInterface?
    let interactor: ThanksForTheInformationInteractorInterface?

    init(
        interactor: ThanksForTheInformationInteractorInterface,
        router: ThanksForTheInformationRouterInterface,
        view: ThanksForTheInformationViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ThanksForTheInformationPresenter: ThanksForTheInformationPresenterInterface {
    func didTapContinueCommonButton() {
        router?.openFinalOfTheFirstStage()
    }
}
