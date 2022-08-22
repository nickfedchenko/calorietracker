//
//  PreviousApplicationPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol PreviousApplicationPresenterInterface: AnyObject {}

class PreviousApplicationPresenter {
    
    unowned var view: PreviousApplicationViewControllerInterface
    let router: PreviousApplicationRouterInterface?
    let interactor: PreviousApplicationInteractorInterface?

    init(
        interactor: PreviousApplicationInteractorInterface,
        router: PreviousApplicationRouterInterface,
        view: PreviousApplicationViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension PreviousApplicationPresenter: PreviousApplicationPresenterInterface {}
