//
//  SearchFoodPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 23.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol SearchFoodPresenterInterface: AnyObject {

}

class SearchFoodPresenter {

    unowned var view: SearchFoodViewControllerInterface
    let router: SearchFoodRouterInterface?
    let interactor: SearchFoodInteractorInterface?

    init(
        interactor: SearchFoodInteractorInterface,
        router: SearchFoodRouterInterface,
        view: SearchFoodViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension SearchFoodPresenter: SearchFoodPresenterInterface {

}
