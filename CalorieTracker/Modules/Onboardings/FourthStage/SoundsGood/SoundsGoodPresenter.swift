//
//  SoundsGoodPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation

protocol SoundsGoodPresenterInterface: AnyObject {
    func didTapContinueCommonButton()
}

class SoundsGoodPresenter {
    
    // MARK: - Public properties

    unowned var view: SoundsGoodViewControllerInterface
    let router: SoundsGoodRouterInterface?
    let interactor: SoundsGoodInteractorInterface?

    // MARK: - Initialization
    
    init(
        interactor: SoundsGoodInteractorInterface,
        router: SoundsGoodRouterInterface,
        view: SoundsGoodViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - SoundsGoodPresenterInterface

extension SoundsGoodPresenter: SoundsGoodPresenterInterface {
    func didTapContinueCommonButton() {
        router?.openDescriptionOfCulinarySkills()
    }
}
