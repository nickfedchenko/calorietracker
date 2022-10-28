//
//  AddFoodPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 28.10.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol AddFoodPresenterInterface: AnyObject {

}

class AddFoodPresenter {

    unowned var view: AddFoodViewControllerInterface
    let router: AddFoodRouterInterface?
    let interactor: AddFoodInteractorInterface?

    init(
        interactor: AddFoodInteractorInterface,
        router: AddFoodRouterInterface,
        view: AddFoodViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension AddFoodPresenter: AddFoodPresenterInterface {

}
