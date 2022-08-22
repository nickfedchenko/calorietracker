//
//  PurposeOfTheParishPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation

protocol PurposeOfTheParishPresenterInterface: AnyObject {}

class PurposeOfTheParishPresenter {
    
    unowned var view: PurposeOfTheParishViewControllerInterface
    let router: PurposeOfTheParishRouterInterface?
    let interactor: PurposeOfTheParishInteractorInterface?

    init(
        interactor: PurposeOfTheParishInteractorInterface,
        router: PurposeOfTheParishRouterInterface,
        view: PurposeOfTheParishViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension PurposeOfTheParishPresenter: PurposeOfTheParishPresenterInterface {}
