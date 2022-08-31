//
//  StressAndEmotionsAreInevitablePresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol StressAndEmotionsAreInevitablePresenterInterface: AnyObject {
    func didTapContinueCommonButton()
}

class StressAndEmotionsAreInevitablePresenter {
    
    // MARK: - Public properties

    unowned var view: StressAndEmotionsAreInevitableViewControllerInterface
    let router: StressAndEmotionsAreInevitableRouterInterface?
    let interactor: StressAndEmotionsAreInevitableInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: StressAndEmotionsAreInevitableInteractorInterface,
        router: StressAndEmotionsAreInevitableRouterInterface,
        view: StressAndEmotionsAreInevitableViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - StressAndEmotionsAreInevitablePresenterInterface

extension StressAndEmotionsAreInevitablePresenter: StressAndEmotionsAreInevitablePresenterInterface {
    func didTapContinueCommonButton() {
        router?.openYoureNotAlone()
    }
}
