//
//  CreateMealPresenter.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 27.02.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Foundation

protocol CreateMealPresenterInterface: AnyObject {

}

class CreateMealPresenter {

    unowned var view: CreateMealViewControllerInterface
    let router: CreateMealRouterInterface?
    let interactor: CreateMealInteractorInterface?

    init(
        interactor: CreateMealInteractorInterface,
        router: CreateMealRouterInterface,
        view: CreateMealViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension CreateMealPresenter: CreateMealPresenterInterface {

}
