//
//  LastCalorieCountPresenter.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import Foundation

protocol LastCalorieCountPresenterInterface: AnyObject {}

class LastCalorieCountPresenter {
    unowned var view: LastCalorieCountViewControllerInterface
    let router: LastCalorieCountRouterInterface?
    let interactor: LastCalorieCountInteractorInterface?

    init(
        interactor: LastCalorieCountInteractorInterface,
        router: LastCalorieCountRouterInterface,
        view: LastCalorieCountViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension LastCalorieCountPresenter: LastCalorieCountPresenterInterface {}
