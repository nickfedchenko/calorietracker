//
//  ThanksForTheInformationPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation

protocol ThanksForTheInformationPresenterInterface: AnyObject {
    func viewDidLoad()
    func didTapContinueCommonButton()
}

class ThanksForTheInformationPresenter {
    
    // MARK: - Public properties

    unowned var view: ThanksForTheInformationViewControllerInterface
    let router: ThanksForTheInformationRouterInterface?
    let interactor: ThanksForTheInformationInteractorInterface?

    // MARK: - Initialization

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

// MARK: - ThanksForTheInformationPresenterInterface

extension ThanksForTheInformationPresenter: ThanksForTheInformationPresenterInterface {
    func viewDidLoad() {
        if let currentOnboardingStage = interactor?.getCurrentOnboardingStage() {
            view.set(currentOnboardingStage: currentOnboardingStage)
        }
    }
    
    func didTapContinueCommonButton() {
        router?.openFinalOfTheFirstStage()
    }
}
